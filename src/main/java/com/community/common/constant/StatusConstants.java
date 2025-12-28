package com.community.common.constant;

/**
 * Status Constants
 */
public class StatusConstants {

    /**
     * Volunteer Status
     */
    public static final String VOLUNTEER_PENDING = "PENDING";
    public static final String VOLUNTEER_APPROVED = "APPROVED";
    public static final String VOLUNTEER_REJECTED = "REJECTED";
    public static final String VOLUNTEER_SUSPENDED = "SUSPENDED";

    /**
     * Demand Status
     */
    public static final String DEMAND_PENDING = "PENDING";
    public static final String DEMAND_APPROVED = "APPROVED";
    public static final String DEMAND_REJECTED = "REJECTED";
    public static final String DEMAND_COMPLETED = "COMPLETED";
    public static final String DEMAND_CANCELLED = "CANCELLED";

    /**
     * Task Status
     */
    public static final String TASK_PENDING = "PENDING";
    public static final String TASK_ONGOING = "ONGOING";
    public static final String TASK_COMPLETED = "COMPLETED";
    public static final String TASK_CANCELLED = "CANCELLED";

    /**
     * Care Plan Status
     */
    public static final String PLAN_ACTIVE = "ACTIVE";
    public static final String PLAN_COMPLETED = "COMPLETED";
    public static final String PLAN_CANCELLED = "CANCELLED";

    /**
     * Feedback Status
     */
    public static final String FEEDBACK_PENDING = "PENDING";
    public static final String FEEDBACK_PROCESSING = "PROCESSING";
    public static final String FEEDBACK_RESOLVED = "RESOLVED";

    /**
     * Feedback Type
     */
    public static final String FEEDBACK_RATING = "RATING";
    public static final String FEEDBACK_SUGGESTION = "SUGGESTION";
    public static final String FEEDBACK_COMPLAINT = "COMPLAINT";

    private StatusConstants() {
        throw new IllegalStateException("Constant class");
    }
}
