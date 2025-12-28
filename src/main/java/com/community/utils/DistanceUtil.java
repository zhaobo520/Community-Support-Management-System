package com.community.utils;

/**
 * 距离计算工具类
 */
public class DistanceUtil {

    private static final double EARTH_RADIUS = 6371000; // 地球半径，单位：米

    /**
     * 计算两点之间的距离（单位：米）
     * @param lat1 点1纬度
     * @param lng1 点1经度
     * @param lat2 点2纬度
     * @param lng2 点2经度
     * @return 距离（米）
     */
    public static double getDistance(double lat1, double lng1, double lat2, double lng2) {
        double radLat1 = Math.toRadians(lat1);
        double radLat2 = Math.toRadians(lat2);
        double a = radLat1 - radLat2;
        double b = Math.toRadians(lng1) - Math.toRadians(lng2);
        
        double s = 2 * Math.asin(Math.sqrt(
            Math.pow(Math.sin(a/2), 2) + 
            Math.cos(radLat1) * Math.cos(radLat2) * Math.pow(Math.sin(b/2), 2)
        ));
        
        s = s * EARTH_RADIUS;
        return Math.round(s * 100) / 100.0; // 保留两位小数
    }
}
