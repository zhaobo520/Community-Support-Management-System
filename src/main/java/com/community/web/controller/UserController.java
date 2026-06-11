package com.community.web.controller;

import com.community.domain.Appeal;
import com.community.domain.CarePlan;
import com.community.domain.Demand;
import com.community.domain.ElderlyInfo;
import com.community.domain.Feedback;
import com.community.domain.Notification;
import com.community.domain.Permission;
import com.community.domain.Role;
import com.community.domain.ServiceRecord;
import com.community.domain.TaskInfo;
import com.community.domain.User;
import com.community.domain.VolunteerProfile;
import com.community.domain.VolunteerSkill;
import com.community.service.AppealService;
import com.community.service.BadgeService;
import com.community.service.CarePlanService;
import com.community.service.DemandService;
import com.community.service.ElderlyService;
import com.community.service.FeedbackService;
import com.community.service.NotificationService;
import com.community.service.PointsService;
import com.community.service.ServiceRecordService;
import com.community.service.SkillService;
import com.community.service.TaskService;
import com.community.service.UserService;
import com.community.service.VolunteerScheduleService;
import com.community.service.VolunteerService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/user")
public class UserController {

  private static final Logger log = LoggerFactory.getLogger(UserController.class);

  @Resource
  private UserService userService;

  @Resource
  private VolunteerService volunteerService;

  @Resource
  private PointsService pointsService;

  @Resource
  private BadgeService badgeService;

  @Resource
  private SkillService skillService;

  @Resource
  private ServiceRecordService serviceRecordService;

  @Resource
  private CarePlanService carePlanService;

  @Resource
  private FeedbackService feedbackService;

  @Resource
  private NotificationService notificationService;

  @Resource
  private VolunteerScheduleService volunteerScheduleService;

  @Resource
  private AppealService appealService;

  @Resource
  private TaskService taskService;

  @Resource
  private ElderlyService elderlyService;

  @Resource
  private DemandService demandService;

  @GetMapping("/login")
  public String loginPage(HttpSession session) {
    if (session != null && session.getAttribute("CURRENT_USER") != null) {
      return "redirect:/user/home";
    }
    return "redirect:/user/admin/login";
  }

  @GetMapping("/admin/login")
  public String adminLoginPage(HttpSession session) {
    if (session != null && session.getAttribute("CURRENT_USER") != null) {
      return "redirect:/user/admin/dashboard";
    }
    return "user/admin_login";
  }

  @GetMapping("/volunteer/login")
  public String volunteerLoginPage(HttpSession session) {
    if (session != null && session.getAttribute("CURRENT_USER") != null) {
      return "redirect:/user/volunteer/dashboard";
    }
    return "user/volunteer_login";
  }

  @GetMapping("/family/login")
  public String familyLoginPage(HttpSession session) {
    if (session != null && session.getAttribute("CURRENT_USER") != null) {
      return "redirect:/user/family/dashboard";
    }
    return "user/family_login";
  }

  @PostMapping("/doLogin")
  public String doLogin(@RequestParam String username,
                        @RequestParam String password,
                        @RequestParam(required = false, defaultValue = "general") String roleHint,
                        HttpSession session,
                        Model model) {
    User user = userService.login(username.trim(), password);
    if (user == null) {
      model.addAttribute("error", "账号或密码错误，或账号被禁用");
      model.addAttribute("username", username);
      // Return to the specific login page based on roleHint
      if ("admin".equals(roleHint)) {
        return "user/admin_login";
      } else if ("volunteer".equals(roleHint)) {
        return "user/volunteer_login";
      } else if ("family".equals(roleHint)) {
        return "user/family_login";
      }
      return "redirect:/user/admin/login";
    }
    
    // 楠岃瘉瑙掕壊鏄惁鍖归厤鐧诲綍鐣岄潰
    String roleType = user.getRoleType();
    boolean roleMatched = true;
    String errorMessage = "";
    
    if ("admin".equals(roleHint)) {
      // 绠＄悊鍛樼櫥褰曠晫闈㈠彧鍏佽STAFF瑙掕壊鐧诲綍
      if (!"STAFF".equals(roleType)) {
        roleMatched = false;
        errorMessage = "此账号不是管理员账号，请使用管理员账号登录";
      }
    } else if ("volunteer".equals(roleHint)) {
      // 蹇楁効鑰呯櫥褰曠晫闈㈠彧鍏佽VOLUNTEER瑙掕壊鐧诲綍
      if (!"VOLUNTEER".equals(roleType)) {
        roleMatched = false;
        errorMessage = "此账号不是志愿者账号，请使用志愿者账号登录";
      }
    } else if ("family".equals(roleHint)) {
      // 瀹跺睘鐧诲綍鐣岄潰鍙厑璁窮AMILY瑙掕壊鐧诲綍
      if (!"FAMILY".equals(roleType)) {
        roleMatched = false;
        errorMessage = "此账号不是家属账号，请使用家属账号登录";
      }
    }
    
    // 濡傛灉瑙掕壊涓嶅尮閰嶏紝杩斿洖鐧诲綍椤甸潰骞舵樉绀洪敊璇俊鎭?
    if (!roleMatched) {
      model.addAttribute("error", errorMessage);
      model.addAttribute("username", username);
      log.warn("鐢ㄦ埛 {} 灏濊瘯鍦▄} 鐧诲綍鐣岄潰浣跨敤 {} 瑙掕壊鐧诲綍", username, roleHint, roleType);
      
      if ("admin".equals(roleHint)) {
        return "user/admin_login";
      } else if ("volunteer".equals(roleHint)) {
        return "user/volunteer_login";
      } else if ("family".equals(roleHint)) {
        return "user/family_login";
      }
      return "redirect:/user/admin/login";
    }
    
    session.setAttribute("CURRENT_USER", user);
    log.info("User {} logged in with role {}", username, user.getRoleType());
    
    // Route to different dashboards based on role
    if ("STAFF".equals(roleType)) {
      return "redirect:/user/admin/dashboard";
    } else if ("VOLUNTEER".equals(roleType)) {
      return "redirect:/user/volunteer/dashboard";
    } else if ("FAMILY".equals(roleType)) {
      return "redirect:/user/family/dashboard";
    }
    return "redirect:/user/home";
  }

  @GetMapping("/home")
  public String home(Model model, HttpSession session) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    model.addAttribute("currentUser", currentUser);
    return "user/home";
  }

  @GetMapping("/admin/dashboard")
  public String adminDashboard(Model model, HttpSession session) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
      return "redirect:/user/login";
    }
    model.addAttribute("currentUser", currentUser);
    return "user/admin_dashboard";
  }

  @GetMapping("/volunteer/dashboard")
  public String volunteerDashboard(Model model, HttpSession session) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"VOLUNTEER".equals(currentUser.getRoleType())) {
      return "redirect:/user/login";
    }

    // 妫€鏌ュ織鎰胯€呯姸鎬?
    VolunteerProfile profile = volunteerService.findByUserId(currentUser.getId());
    if (profile == null) {
      model.addAttribute("errorMsg", "您还未注册成为志愿者，请先完善志愿者信息");
      return "error/volunteer_not_registered";
    }

    if ("REJECTED".equals(profile.getVolunteerStatus())) {
      model.addAttribute("errorMsg", "您的志愿者申请已被拒绝，暂时无法接单");
      return "error/volunteer_rejected";
    }

    if ("SUSPENDED".equals(profile.getVolunteerStatus())) {
      model.addAttribute("errorMsg", "您的志愿者服务已被暂停，暂时无法接单");
      return "error/volunteer_suspended";
    }

    if ("PENDING".equals(profile.getVolunteerStatus())) {
      model.addAttribute("errorMsg", "您的志愿者申请正在审核中，请耐心等待");
      return "error/volunteer_pending";
    }

    // 鑾峰彇绉垎鍜屾帓鍚嶄俊鎭?
    Integer totalPoints = 0;
    Integer ranking = 0;
    int badgeCount = 0;
    
    if (pointsService != null) {
      try {
        totalPoints = pointsService.getUserTotalPoints(currentUser.getId());
        ranking = pointsService.getUserRanking(currentUser.getId());
      } catch (Exception e) {
        log.warn("鑾峰彇绉垎淇℃伅澶辫触", e);
      }
    }
    
    if (badgeService != null) {
      try {
        badgeCount = badgeService.countUserBadges(currentUser.getId());
      } catch (Exception e) {
        log.warn("鑾峰彇鍕嬬珷淇℃伅澶辫触", e);
      }
    }

    // 鑾峰彇鎶€鑳藉垪琛?
    List<VolunteerSkill> mySkills = null;
    if (skillService != null) {
      try {
        mySkills = skillService.getVolunteerSkills(currentUser.getId());
      } catch (Exception e) {
        log.warn("获取技能列表失败", e);
      }
    }
    
    // 鑾峰彇閫氱煡淇℃伅
    int unreadCount = 0;
    List<Notification> recentNotifications = null;
    if (notificationService != null) {
      try {
        unreadCount = notificationService.countUnread(currentUser.getId());
        List<Notification> allNotifications = notificationService.findByUserId(currentUser.getId(), null);
        if (allNotifications != null && !allNotifications.isEmpty()) {
          // 鍙栧墠3鏉?
          recentNotifications = allNotifications.stream().limit(3).collect(Collectors.toList());
        }
      } catch (Exception e) {
        log.warn("鑾峰彇閫氱煡淇℃伅澶辫触", e);
      }
    }
    
    model.addAttribute("currentUser", currentUser);
    model.addAttribute("totalPoints", totalPoints != null ? totalPoints : 0);
    model.addAttribute("ranking", ranking != null ? ranking : 0);
    model.addAttribute("badgeCount", badgeCount);
    model.addAttribute("mySkills", mySkills != null ? mySkills : new java.util.ArrayList<>());
    model.addAttribute("unreadCount", unreadCount);
    model.addAttribute("recentNotifications", recentNotifications != null ? recentNotifications : new java.util.ArrayList<>());
    
    return "user/volunteer_dashboard";
  }

  @GetMapping("/family/dashboard")
  public String familyDashboard(Model model, HttpSession session) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"FAMILY".equals(currentUser.getRoleType())) {
      return "redirect:/user/login";
    }
    
    // 缁熻寰呭姙浜嬮」鏁伴噺锛堣繘琛屼腑鐨勫叧鎬€璁″垝锛?
    int pendingCount = 0;
    // 缁熻鏈嶅姟璁板綍鏁伴噺锛堝疄闄呭畬鎴愮殑鏈嶅姟璁板綍锛?
    int serviceCount = 0;
    
    if (carePlanService != null) {
      try {
        // 缁熻杩涜涓殑鍏虫€€璁″垝
        pendingCount = carePlanService.countActiveByFamilyUserId(currentUser.getId());
      } catch (Exception e) {
        log.warn("鑾峰彇寰呭姙浜嬮」缁熻澶辫触", e);
      }
    }
    
    if (serviceRecordService != null) {
      try {
        // 缁熻瀹為檯鐨勬湇鍔¤褰曟暟閲?
        serviceCount = serviceRecordService.countByFamilyUserId(currentUser.getId());
      } catch (Exception e) {
        log.warn("鑾峰彇鏈嶅姟璁板綍缁熻澶辫触", e);
      }
    }
    
    model.addAttribute("currentUser", currentUser);
    model.addAttribute("pendingCount", pendingCount);
    model.addAttribute("serviceCount", serviceCount);
    return "user/family_dashboard";
  }

  @GetMapping("/family/volunteers")
  public String familyVolunteers(Model model, HttpSession session) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"FAMILY".equals(currentUser.getRoleType())) {
      return "redirect:/user/login";
    }
    
    // 鑾峰彇鎵€鏈夊凡璁よ瘉鐨勫織鎰胯€?
    List<VolunteerProfile> volunteers = volunteerService.findAll("APPROVED", null);
    
    // 涓烘瘡涓織鎰胯€呭姞杞芥妧鑳芥爣绛?
    if (skillService != null && volunteers != null) {
      for (VolunteerProfile volunteer : volunteers) {
        try {
          List<VolunteerSkill> skills = skillService.getVolunteerSkills(volunteer.getUserId());
          volunteer.setSkillList(skills);
        } catch (Exception e) {
          log.warn("加载志愿者技能失败, userId=" + volunteer.getUserId(), e);
        }
      }
    }
    
    model.addAttribute("currentUser", currentUser);
    model.addAttribute("volunteers", volunteers);
    return "user/family_volunteers";
  }

  @GetMapping("/logout")
  public String logout(HttpSession session) {
    String redirectUrl = "/user/login";
    
    if (session != null) {
      User currentUser = (User) session.getAttribute("CURRENT_USER");
      if (currentUser != null) {
        String roleType = currentUser.getRoleType();
        if ("STAFF".equals(roleType)) {
          redirectUrl = "/user/admin/login";
        } else if ("VOLUNTEER".equals(roleType)) {
          redirectUrl = "/user/volunteer/login";
        } else if ("FAMILY".equals(roleType)) {
          redirectUrl = "/user/family/login";
        }
      }
      session.invalidate();
    }
    return "redirect:" + redirectUrl;
  }

  @GetMapping("/profile")
  public String profile(Model model, HttpSession session) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null) {
      return "redirect:/user/login";
    }
    
    User fresh = userService.findById(currentUser.getId());
    session.setAttribute("CURRENT_USER", fresh);
    model.addAttribute("currentUser", fresh);
    
    // 鏍规嵁瑙掕壊绫诲瀷璺宠浆鍒颁笉鍚岀殑涓汉涓績椤甸潰
    String roleType = fresh.getRoleType();
    if ("STAFF".equals(roleType)) {
      // 绠＄悊鍛樹釜浜轰腑蹇?
      return "user/profile_admin";
    } else if ("VOLUNTEER".equals(roleType)) {
      // 蹇楁効鑰呬釜浜轰腑蹇?- 娣诲姞鎶€鑳戒俊鎭?
      List<VolunteerSkill> mySkills = null;
      if (skillService != null) {
        try {
          mySkills = skillService.getVolunteerSkills(fresh.getId());
        } catch (Exception e) {
          log.warn("获取技能列表失败", e);
        }
      }
      model.addAttribute("mySkills", mySkills != null ? mySkills : new java.util.ArrayList<>());
      return "user/profile_volunteer";
    } else if ("FAMILY".equals(roleType)) {
      // 瀹跺睘涓汉涓績
      return "user/profile_family";
    }
    
    return "user/user_info";
  }

  @PostMapping("/profile")
  public String updateProfile(@RequestParam Long id,
                              @RequestParam String fullName,
                              @RequestParam String phone,
                              @RequestParam String email,
                              @RequestParam(required = false) String avatar,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
    User update = new User();
    update.setId(id);
    update.setFullName(fullName);
    update.setPhone(phone);
    update.setEmail(email);
    update.setAvatar(avatar);
    
    // 修正：从数据库获取当前密码，防止 update 方法将其覆盖为 null
    User originalUser = userService.findById(id);
    if (originalUser != null) {
        update.setPassword(originalUser.getPassword());
    }

    boolean success = userService.updateProfile(update);
    if (success) {
      User refreshed = userService.findById(id);
      session.setAttribute("CURRENT_USER", refreshed);
      redirectAttributes.addFlashAttribute("msg", "资料已更新");
    } else {
      redirectAttributes.addFlashAttribute("msg", "资料更新失败，请稍后再试");
    }
    return "redirect:/user/profile";
  }

  /**
   * AJAX更新头像
   */
  @PostMapping("/updateAvatar")
  @ResponseBody
  public Map<String, Object> updateAvatar(@RequestParam Long id,
                                          @RequestParam String avatar,
                                          HttpSession session) {
    Map<String, Object> result = new HashMap<>();
    try {
      // 必须先获取原用户，防止丢失其他字段
      User update = userService.findById(id);
      if (update == null) {
          result.put("success", false);
          result.put("message", "用户不存在");
          return result;
      }
      
      update.setAvatar(avatar);
      boolean success = userService.updateProfile(update);
      if (success) {
        User refreshed = userService.findById(id);
        session.setAttribute("CURRENT_USER", refreshed);
        result.put("success", true);
        result.put("message", "头像更新成功");
      } else {
        result.put("success", false);
        result.put("message", "头像更新失败");
      }
    } catch (Exception e) {
      result.put("success", false);
      result.put("message", "头像更新失败：" + e.getMessage());
    }
    return result;
  }

  /**
   * 绠＄悊鍛樹釜浜轰腑蹇?
   */
  @GetMapping("/admin/profile")
  public String adminProfile(Model model, HttpSession session) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
      return "redirect:/user/login";
    }

    // 鑾峰彇鎵€鏈夌鐞嗗憳鍒楄〃
    List<User> adminList = userService.listAll().stream()
        .filter(u -> "STAFF".equals(u.getRoleType()))
        .collect(Collectors.toList());

    model.addAttribute("currentUser", currentUser);
    model.addAttribute("adminList", adminList);
    return "user/admin_profile";
  }

  /**
   * 娣诲姞绠＄悊鍛?
   */
  @PostMapping("/admin/add")
  public String addAdmin(User user, HttpSession session, RedirectAttributes redirectAttributes) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
      return "redirect:/user/login";
    }

    try {
      // 璁剧疆瑙掕壊涓虹鐞嗗憳
      user.setRoleType("STAFF");
      user.setStatus(1);
      
      // 鍒涘缓绠＄悊鍛樿处鍙?
      boolean created = userService.register(user);
      if (!created) {
        redirectAttributes.addFlashAttribute("error", "用户名或手机号已存在");
        return "redirect:/user/admin/profile";
      }
      
      redirectAttributes.addFlashAttribute("msg", "管理员添加成功");
      return "redirect:/user/admin/profile";
    } catch (Exception e) {
      log.error("添加管理员失败", e);
      redirectAttributes.addFlashAttribute("error", "添加失败，请稍后重试");
      return "redirect:/user/admin/profile";
    }
  }

  /**
   * 蹇楁効鑰呮敞鍐岄〉闈?
   */
  @GetMapping("/volunteer/register")
  public String volunteerRegisterPage() {
    return "user/volunteer_register";
  }

  /**
   * 蹇楁効鑰呮敞鍐屾彁浜?
   */
  @PostMapping("/volunteer/register")
  public String volunteerRegister(User user, VolunteerProfile profile, RedirectAttributes redirectAttributes) {
    try {
      // 璁剧疆瑙掕壊涓哄織鎰胯€?
      user.setRoleType("VOLUNTEER");
      user.setStatus(1);
      
      // 鍒涘缓鐢ㄦ埛璐﹀彿
      boolean userCreated = userService.register(user);
      if (!userCreated) {
        redirectAttributes.addFlashAttribute("error", "用户名或手机号已存在");
        return "redirect:/user/volunteer/register";
      }
      
      // 鑾峰彇鏂板垱寤虹殑鐢ㄦ埛ID
      User createdUser = userService.findByUsername(user.getUsername());
      if (createdUser != null) {
        // 鍒涘缓蹇楁効鑰呮。妗?
        profile.setUserId(createdUser.getId());
        profile.setVolunteerStatus("PENDING"); // 璁剧疆涓哄緟瀹℃牳
        volunteerService.add(profile);
      }
      
      redirectAttributes.addFlashAttribute("msg", "注册成功！请等待管理员审核");
      return "redirect:/user/volunteer/login";
    } catch (Exception e) {
      log.error("志愿者注册失败", e);
      redirectAttributes.addFlashAttribute("error", "注册失败，请稍后重试");
      return "redirect:/user/volunteer/register";
    }
  }

  /**
   * 瀹跺睘娉ㄥ唽椤甸潰
   */
  @GetMapping("/family/register")
  public String familyRegisterPage() {
    return "user/family_register";
  }

  /**
   * 瀹跺睘娉ㄥ唽鎻愪氦
   */
  @PostMapping("/family/register")
  public String familyRegister(User user, RedirectAttributes redirectAttributes) {
    try {
      // 璁剧疆瑙掕壊涓哄灞?
      user.setRoleType("FAMILY");
      user.setStatus(1);
      
      // 鍒涘缓鐢ㄦ埛璐﹀彿
      boolean userCreated = userService.register(user);
      if (!userCreated) {
        redirectAttributes.addFlashAttribute("error", "用户名或手机号已存在");
        return "redirect:/user/family/register";
      }
      
      redirectAttributes.addFlashAttribute("msg", "注册成功！请使用账号登录");
      return "redirect:/user/family/login";
    } catch (Exception e) {
      log.error("瀹跺睘娉ㄥ唽澶辫触", e);
      redirectAttributes.addFlashAttribute("error", "注册失败，请稍后重试");
      return "redirect:/user/family/register";
    }
  }

  /**
   * 瀹跺睘鍏崇埍璁″垝椤甸潰
   */
  @GetMapping("/family/care-plans")
  public String familyCarePlans(Model model, HttpSession session) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"FAMILY".equals(currentUser.getRoleType())) {
      return "redirect:/user/login";
    }
    
    // 鑾峰彇鍏崇埍璁″垝鍒楄〃
    List<CarePlan> plans = carePlanService.findByFamilyUserId(currentUser.getId());
    int totalPlans = carePlanService.countByFamilyUserId(currentUser.getId());
    int activePlans = carePlanService.countActiveByFamilyUserId(currentUser.getId());
    
    model.addAttribute("currentUser", currentUser);
    model.addAttribute("plans", plans != null ? plans : new java.util.ArrayList<>());
    model.addAttribute("totalPlans", totalPlans);
    model.addAttribute("activePlans", activePlans);
    
    return "user/family_care_plans";
  }

  /**
   * 家属关爱计划详情页面
   */
  @GetMapping("/family/care-plan/detail/{id}")
  public String familyCarePlanDetail(@PathVariable Long id, Model model, HttpSession session) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"FAMILY".equals(currentUser.getRoleType())) {
      return "redirect:/user/login";
    }

    CarePlan plan = carePlanService.findById(id);
    if (plan == null || !currentUser.getId().equals(plan.getFamilyUserId())) {
      return "redirect:/user/family/care-plans";
    }

    // 获取关联的关爱对象信息
    ElderlyInfo elderlyInfo = null;
    if (plan.getElderlyId() != null) {
      elderlyInfo = elderlyService.findById(plan.getElderlyId());
    }

    // 获取志愿者信息
    User volunteer = null;
    if (plan.getAssignedVolunteerId() != null) {
      volunteer = userService.findById(plan.getAssignedVolunteerId());
    }

    model.addAttribute("currentUser", currentUser);
    model.addAttribute("plan", plan);
    model.addAttribute("elderlyInfo", elderlyInfo);
    model.addAttribute("volunteer", volunteer);

    return "user/family_care_plan_detail";
  }

  /**
   * 家属服务记录页面 - 显示需求及其状态
   */
  @GetMapping("/family/service-records")
  public String familyServiceRecords(Model model, HttpSession session) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"FAMILY".equals(currentUser.getRoleType())) {
      return "redirect:/user/login";
    }

    // 获取家属发布的所有需求
    List<Demand> demands = demandService.findByFamilyUserId(currentUser.getId());

    // 创建一个Map来存储每个需求关联的任务信息
    Map<Long, TaskInfo> demandTaskMap = new HashMap<>();
    if (demands != null) {
      for (Demand demand : demands) {
        if (demand.getTaskId() != null) {
          TaskInfo task = taskService.findById(demand.getTaskId());
          if (task != null) {
            demandTaskMap.put(demand.getId(), task);
          }
        }
      }
    }

    // 统计各状态数量 - 优先根据任务状态判断
    int totalDemands = demands != null ? demands.size() : 0;
    int pendingCount = 0;
    int approvedCount = 0;
    int inProgressCount = 0;
    int completedCount = 0;
    int rejectedCount = 0;

    if (demands != null) {
      for (Demand d : demands) {
        TaskInfo task = demandTaskMap.get(d.getId());

        // 优先根据任务状态判断，如果有任务说明需求已通过审核
        if (task != null) {
          String taskStatus = task.getStatus();
          if ("COMPLETED".equals(taskStatus) || "APPROVED".equals(taskStatus)) {
            completedCount++;
          } else if ("IN_PROGRESS".equals(taskStatus) || "CLAIMED".equals(taskStatus)) {
            inProgressCount++;
          } else {
            approvedCount++; // 任务待领取
          }
        } else {
          // 没有任务，根据需求状态判断
          String status = d.getStatus();
          if ("REJECTED".equals(status)) {
            rejectedCount++;
          } else if ("APPROVED".equals(status)) {
            approvedCount++;
          } else if ("COMPLETED".equals(status)) {
            completedCount++;
          } else {
            pendingCount++; // PENDING 或其他状态
          }
        }
      }
    }

    model.addAttribute("currentUser", currentUser);
    model.addAttribute("demands", demands != null ? demands : new java.util.ArrayList<>());
    model.addAttribute("demandTaskMap", demandTaskMap);
    model.addAttribute("totalDemands", totalDemands);
    model.addAttribute("pendingCount", pendingCount);
    model.addAttribute("approvedCount", approvedCount);
    model.addAttribute("inProgressCount", inProgressCount);
    model.addAttribute("completedCount", completedCount);
    model.addAttribute("rejectedCount", rejectedCount);

    return "user/family_service_records";
  }

  /**
   * 家属查看任务详情（只读模式）
   */
  @GetMapping("/family/task/detail/{id}")
  public String familyTaskDetail(@PathVariable Long id, Model model, HttpSession session) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"FAMILY".equals(currentUser.getRoleType())) {
      return "redirect:/user/login";
    }

    TaskInfo taskInfo = taskService.findById(id);
    if (taskInfo == null) {
      return "redirect:/user/family/service-records";
    }

    model.addAttribute("taskInfo", taskInfo);
    model.addAttribute("currentUser", currentUser);
    return "user/family_task_detail";
  }

  /**
   * 家属关爱人员列表页面
   */
  @GetMapping("/family/elderly/list")
  public String familyElderlyList(Model model, HttpSession session) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"FAMILY".equals(currentUser.getRoleType())) {
      return "redirect:/user/login";
    }

    List<ElderlyInfo> elderlyList = elderlyService.findByFamilyUserId(currentUser.getId());
    int totalCount = elderlyService.countByFamilyUserId(currentUser.getId());
    int approvedCount = elderlyService.countApprovedByFamilyUserId(currentUser.getId());
    int pendingCount = totalCount - approvedCount;

    model.addAttribute("currentUser", currentUser);
    model.addAttribute("elderlyList", elderlyList);
    model.addAttribute("totalCount", totalCount);
    model.addAttribute("approvedCount", approvedCount);
    model.addAttribute("pendingCount", pendingCount);

    return "user/family_elderly_list";
  }

  /**
   * 家属添加关爱人员页面
   */
  @GetMapping("/family/elderly/add")
  public String familyElderlyAddPage(Model model, HttpSession session) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"FAMILY".equals(currentUser.getRoleType())) {
      return "redirect:/user/login";
    }

    model.addAttribute("currentUser", currentUser);
    return "user/family_elderly_add";
  }

  /**
   * 家属添加关爱人员提交
   */
  @PostMapping("/family/elderly/add")
  public String familyElderlyAddSubmit(ElderlyInfo elderlyInfo, HttpSession session, RedirectAttributes redirectAttributes) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"FAMILY".equals(currentUser.getRoleType())) {
      return "redirect:/user/login";
    }

    // 设置家属用户ID和审核状态
    elderlyInfo.setFamilyUserId(currentUser.getId());
    elderlyInfo.setAuditStatus("PENDING");
    elderlyInfo.setStatus(1);
    elderlyInfo.setCreatedBy(currentUser.getId());
    // 设置家属电话为当前用户电话
    if (elderlyInfo.getFamilyPhone() == null || elderlyInfo.getFamilyPhone().isEmpty()) {
      elderlyInfo.setFamilyPhone(currentUser.getPhone());
    }

    boolean success = false;
    try {
      success = elderlyService.add(elderlyInfo);
    } catch (Exception e) {
      log.error("Failed to add elderly info", e);
      redirectAttributes.addFlashAttribute("error", "系统错误，请稍后重试：" + e.getMessage());
      return "redirect:/user/family/elderly/add";
    }
    if (success) {
      redirectAttributes.addFlashAttribute("success", "关爱人员添加成功，请等待管理员审核");
    } else {
      redirectAttributes.addFlashAttribute("error", "添加失败，身份证号可能已存在");
      return "redirect:/user/family/elderly/add";
    }

    return "redirect:/user/family/elderly/list";
  }

  /**
   * 家属查看关爱人员详情
   */
  @GetMapping("/family/elderly/detail/{id}")
  public String familyElderlyDetail(@PathVariable Long id, Model model, HttpSession session) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"FAMILY".equals(currentUser.getRoleType())) {
      return "redirect:/user/login";
    }

    ElderlyInfo elderlyInfo = elderlyService.findById(id);
    if (elderlyInfo == null || !currentUser.getId().equals(elderlyInfo.getFamilyUserId())) {
      return "redirect:/user/family/elderly/list";
    }

    model.addAttribute("currentUser", currentUser);
    model.addAttribute("elderlyInfo", elderlyInfo);
    return "user/family_elderly_detail";
  }

  /**
   * 家属编辑关爱人员页面
   */
  @GetMapping("/family/elderly/edit/{id}")
  public String familyElderlyEditPage(@PathVariable Long id, Model model, HttpSession session) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"FAMILY".equals(currentUser.getRoleType())) {
      return "redirect:/user/login";
    }

    ElderlyInfo elderlyInfo = elderlyService.findById(id);
    if (elderlyInfo == null || !currentUser.getId().equals(elderlyInfo.getFamilyUserId())) {
      return "redirect:/user/family/elderly/list";
    }

    model.addAttribute("currentUser", currentUser);
    model.addAttribute("elderlyInfo", elderlyInfo);
    return "user/family_elderly_edit";
  }

  /**
   * 家属编辑关爱人员提交
   */
  @PostMapping("/family/elderly/edit")
  public String familyElderlyEditSubmit(ElderlyInfo elderlyInfo, HttpSession session, RedirectAttributes redirectAttributes) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"FAMILY".equals(currentUser.getRoleType())) {
      return "redirect:/user/login";
    }

    // 验证是否是自己的关爱人员
    ElderlyInfo existing = elderlyService.findById(elderlyInfo.getId());
    if (existing == null || !currentUser.getId().equals(existing.getFamilyUserId())) {
      return "redirect:/user/family/elderly/list";
    }

    // 重新提交审核
    elderlyInfo.setFamilyUserId(currentUser.getId());
    elderlyInfo.setAuditStatus("PENDING");
    elderlyInfo.setStatus(1);

    boolean success = elderlyService.update(elderlyInfo);
    if (success) {
      redirectAttributes.addFlashAttribute("success", "修改成功，请等待管理员重新审核");
    } else {
      redirectAttributes.addFlashAttribute("error", "修改失败");
    }

    return "redirect:/user/family/elderly/list";
  }

  /**
   * 瀹跺睘鍙嶉鍒楄〃椤甸潰
   */
  @GetMapping("/family/feedback/list")
  public String familyFeedbackList(Model model, HttpSession session) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"FAMILY".equals(currentUser.getRoleType())) {
      return "redirect:/user/login";
    }
    
    // 鑾峰彇鍙嶉鍒楄〃
    List<Feedback> feedbacks = feedbackService.findByFamilyUserId(currentUser.getId());
    int totalFeedbacks = feedbackService.countByFamilyUserId(currentUser.getId());
    int pendingFeedbacks = feedbackService.countPendingByFamilyUserId(currentUser.getId());
    
    model.addAttribute("currentUser", currentUser);
    model.addAttribute("feedbacks", feedbacks != null ? feedbacks : new java.util.ArrayList<>());
    model.addAttribute("totalFeedbacks", totalFeedbacks);
    model.addAttribute("pendingFeedbacks", pendingFeedbacks);
    
    return "user/family_feedback_list";
  }

  /**
   * 瀹跺睘鎻愪氦鍙嶉椤甸潰
   */
  @GetMapping("/family/feedback/submit")
  public String familyFeedbackSubmitPage(Model model, HttpSession session) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"FAMILY".equals(currentUser.getRoleType())) {
      return "redirect:/user/login";
    }
    
    model.addAttribute("currentUser", currentUser);
    return "user/family_feedback_submit";
  }

  /**
   * 瀹跺睘鎻愪氦鍙嶉澶勭悊
   */
  @PostMapping("/family/feedback/submit")
  public String familyFeedbackSubmit(Feedback feedback, HttpSession session, RedirectAttributes redirectAttributes) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"FAMILY".equals(currentUser.getRoleType())) {
      return "redirect:/user/login";
    }
    
    try {
      feedback.setFamilyUserId(currentUser.getId());
      feedback.setStatus("PENDING");
      
      boolean success = feedbackService.submit(feedback);
      if (success) {
        redirectAttributes.addFlashAttribute("msg", "反馈提交成功！");
      } else {
        redirectAttributes.addFlashAttribute("error", "提交失败，请重试");
      }
    } catch (Exception e) {
      log.error("Submit feedback failed", e);
      redirectAttributes.addFlashAttribute("error", "提交失败：" + e.getMessage());
    }
    
    return "redirect:/user/family/feedback/list";
  }

  /**
   * 瀹跺睘绱ф€ヨ仈绯婚〉闈?
   */
  @GetMapping("/family/emergency-contact")
  public String familyEmergencyContact(Model model, HttpSession session) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"FAMILY".equals(currentUser.getRoleType())) {
      return "redirect:/user/login";
    }
    
    // 鏌ヨ绠＄悊鍛橈紙绀惧尯宸ヤ綔浜哄憳锛?
    List<User> staffList = userService.findByRoleType("STAFF");
    
    // 鏌ヨ蹇楁効鑰?
    List<VolunteerProfile> volunteers = volunteerService.findAll("APPROVED", null);
    
    model.addAttribute("currentUser", currentUser);
    model.addAttribute("staffList", staffList != null ? staffList : new java.util.ArrayList<>());
    model.addAttribute("volunteers", volunteers != null ? volunteers : new java.util.ArrayList<>());
    
    return "user/family_emergency_contact";
  }

  @GetMapping("/permissions")
  @ResponseBody
  public Map<String, Object> permissions(HttpSession session) {
    User current = (User) session.getAttribute("CURRENT_USER");
    Map<String, Object> payload = new HashMap<>();
    if (current == null) {
      payload.put("authenticated", false);
      return payload;
    }
    List<Role> roles = userService.findRoles(current.getId());
    List<Permission> permissions = userService.findPermissions(current.getId());
    payload.put("authenticated", true);
    payload.put("username", current.getUsername());
    payload.put("roles", roles.stream().map(Role::getRoleName).collect(Collectors.toList()));
    payload.put("permissions", permissions.stream().map(Permission::getPermCode).collect(Collectors.toSet()));
    return payload;
  }

  @GetMapping("/volunteer/appeal")
  public String volunteerAppealPage() {
    return "user/volunteer_appeal";
  }

  @GetMapping("/volunteer/reset-password")
  public String volunteerResetPasswordPage() {
    return "user/volunteer_reset_password";
  }

  @PostMapping("/volunteer/submit-appeal")
  public String submitVolunteerAppeal(@RequestParam String username,
                                      @RequestParam String phone,
                                      @RequestParam String appealType,
                                      @RequestParam String description,
                                      @RequestParam(required = false) String attachment,
                                      HttpSession session,
                                      RedirectAttributes redirectAttributes) {
    try {
      User currentUser = (User) session.getAttribute("CURRENT_USER");

      Appeal appeal = new Appeal();
      appeal.setUsername(username);
      appeal.setPhone(phone);
      appeal.setAppealType(appealType);
      appeal.setDescription(description);
      appeal.setAttachment(attachment);
      appeal.setUserRole("VOLUNTEER");
      if (currentUser != null) {
        appeal.setUserId(currentUser.getId());
      }

      boolean success = appealService.submit(appeal);
      if (success) {
        redirectAttributes.addFlashAttribute("msg", "申诉已提交，管理员会在24小时内回复");
      } else {
        redirectAttributes.addFlashAttribute("error", "申诉提交失败，请稍后重试");
      }
    } catch (Exception e) {
      log.error("Submit volunteer appeal failed", e);
      redirectAttributes.addFlashAttribute("error", "申诉提交失败：" + e.getMessage());
    }
    return "redirect:/user/volunteer/login";
  }

  @PostMapping("/volunteer/update-password")
  public String updateVolunteerPassword(@RequestParam String username,
                                        @RequestParam String phone,
                                        @RequestParam String oldPassword,
                                        @RequestParam String newPassword,
                                        RedirectAttributes redirectAttributes) {
    try {
      User user = userService.findByUsername(username);
      if (user == null) {
        redirectAttributes.addFlashAttribute("error", "用户不存在");
        return "redirect:/user/volunteer/reset-password";
      }

      // 楠岃瘉鎵嬫満鍙锋槸鍚﹀尮閰?
      if (!phone.equals(user.getPhone())) {
        redirectAttributes.addFlashAttribute("error", "手机号不匹配");
        return "redirect:/user/volunteer/reset-password";
      }

      // 璋冪敤service淇敼瀵嗙爜
      boolean success = userService.updatePassword(user.getId(), oldPassword, newPassword);
      if (success) {
        redirectAttributes.addFlashAttribute("msg", "密码修改成功，请使用新密码登录");
      } else {
        redirectAttributes.addFlashAttribute("error", "原密码错误，密码修改失败");
      }
    } catch (Exception e) {
      log.error("Update volunteer password failed", e);
      redirectAttributes.addFlashAttribute("error", "密码修改失败：" + e.getMessage());
    }
    return "redirect:/user/volunteer/login";
  }

  @GetMapping("/family/appeal")
  public String familyAppealPage() {
    return "user/family_appeal";
  }

  @GetMapping("/family/reset-password")
  public String familyResetPasswordPage() {
    return "user/family_reset_password";
  }

  @PostMapping("/family/submit-appeal")
  public String submitFamilyAppeal(@RequestParam String username,
                                   @RequestParam String phone,
                                   @RequestParam String appealType,
                                   @RequestParam String description,
                                   @RequestParam(required = false) String attachment,
                                   HttpSession session,
                                   RedirectAttributes redirectAttributes) {
    try {
      User currentUser = (User) session.getAttribute("CURRENT_USER");

      Appeal appeal = new Appeal();
      appeal.setUsername(username);
      appeal.setPhone(phone);
      appeal.setAppealType(appealType);
      appeal.setDescription(description);
      appeal.setAttachment(attachment);
      appeal.setUserRole("FAMILY");
      if (currentUser != null) {
        appeal.setUserId(currentUser.getId());
      }

      boolean success = appealService.submit(appeal);
      if (success) {
        redirectAttributes.addFlashAttribute("msg", "申诉已提交，管理员会在24小时内回复");
      } else {
        redirectAttributes.addFlashAttribute("error", "申诉提交失败，请稍后重试");
      }
    } catch (Exception e) {
      log.error("Submit family appeal failed", e);
      redirectAttributes.addFlashAttribute("error", "申诉提交失败：" + e.getMessage());
    }
    return "redirect:/user/family/login";
  }

  @PostMapping("/family/update-password")
  public String updateFamilyPassword(@RequestParam String username,
                                     @RequestParam String phone,
                                     @RequestParam String oldPassword,
                                     @RequestParam String newPassword,
                                     RedirectAttributes redirectAttributes) {
    try {
      User user = userService.findByUsername(username);
      if (user == null) {
        redirectAttributes.addFlashAttribute("error", "用户不存在");
        return "redirect:/user/family/reset-password";
      }

      // 楠岃瘉鎵嬫満鍙锋槸鍚﹀尮閰?
      if (!phone.equals(user.getPhone())) {
        redirectAttributes.addFlashAttribute("error", "手机号不匹配");
        return "redirect:/user/family/reset-password";
      }

      // 璋冪敤service淇敼瀵嗙爜
      boolean success = userService.updatePassword(user.getId(), oldPassword, newPassword);
      if (success) {
        redirectAttributes.addFlashAttribute("msg", "密码修改成功，请使用新密码登录");
      } else {
        redirectAttributes.addFlashAttribute("error", "原密码错误，密码修改失败");
      }
    } catch (Exception e) {
      log.error("Update family password failed", e);
      redirectAttributes.addFlashAttribute("error", "密码修改失败：" + e.getMessage());
    }
    return "redirect:/user/family/login";
  }
}
