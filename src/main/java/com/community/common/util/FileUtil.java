package com.community.common.util;

import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * File Upload Utility
 */
public class FileUtil {

    // Allowed image extensions
    private static final Set<String> ALLOWED_IMAGE_EXTENSIONS = new HashSet<>(
        Arrays.asList("jpg", "jpeg", "png", "gif", "bmp", "webp")
    );

    // Allowed document extensions
    private static final Set<String> ALLOWED_DOC_EXTENSIONS = new HashSet<>(
        Arrays.asList("pdf", "doc", "docx", "xls", "xlsx", "txt")
    );

    // Allowed video extensions
    private static final Set<String> ALLOWED_VIDEO_EXTENSIONS = new HashSet<>(
        Arrays.asList("mp4", "avi", "mov", "wmv", "flv", "webm", "mkv", "m4v")
    );

    // Max file size (10MB)
    private static final long MAX_FILE_SIZE = 10 * 1024 * 1024;

    // Max video size (100MB)
    private static final long MAX_VIDEO_SIZE = 100 * 1024 * 1024;

    // Max image size (5MB)
    private static final long MAX_IMAGE_SIZE = 5 * 1024 * 1024;

    private FileUtil() {
        throw new IllegalStateException("Utility class");
    }

    /**
     * Upload file
     */
    public static String uploadFile(MultipartFile file, String uploadDir, String fileType) throws IOException {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("File is empty");
        }

        // Validate file size
        validateFileSize(file, fileType);

        // Validate file extension
        String extension = getFileExtension(file.getOriginalFilename());
        validateFileExtension(extension, fileType);

        // Create upload directory if not exists
        File dir = new File(uploadDir);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        // Generate unique filename
        String filename = generateUniqueFilename(extension);

        // Save file
        File destFile = new File(uploadDir, filename);
        file.transferTo(destFile);

        return filename;
    }

    /**
     * Upload image
     */
    public static String uploadImage(MultipartFile file, String uploadDir) throws IOException {
        return uploadFile(file, uploadDir, "image");
    }

    /**
     * Upload document
     */
    public static String uploadDocument(MultipartFile file, String uploadDir) throws IOException {
        return uploadFile(file, uploadDir, "document");
    }

    /**
     * Upload video
     */
    public static String uploadVideo(MultipartFile file, String uploadDir) throws IOException {
        return uploadFile(file, uploadDir, "video");
    }

    /**
     * Delete file
     */
    public static boolean deleteFile(String filePath) {
        if (StringUtil.isEmpty(filePath)) {
            return false;
        }
        File file = new File(filePath);
        return file.exists() && file.delete();
    }

    /**
     * Get file extension
     */
    public static String getFileExtension(String filename) {
        if (StringUtil.isEmpty(filename)) {
            return "";
        }
        int dotIndex = filename.lastIndexOf('.');
        if (dotIndex == -1 || dotIndex == filename.length() - 1) {
            return "";
        }
        return filename.substring(dotIndex + 1).toLowerCase();
    }

    /**
     * Generate unique filename
     */
    public static String generateUniqueFilename(String extension) {
        String timestamp = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
        String random = UUID.randomUUID().toString().substring(0, 8);
        return timestamp + "_" + random + "." + extension;
    }

    /**
     * Validate file size
     */
    private static void validateFileSize(MultipartFile file, String fileType) {
        long size = file.getSize();
        long maxSize;
        if ("image".equals(fileType)) {
            maxSize = MAX_IMAGE_SIZE;
        } else if ("video".equals(fileType)) {
            maxSize = MAX_VIDEO_SIZE;
        } else {
            maxSize = MAX_FILE_SIZE;
        }

        if (size > maxSize) {
            throw new IllegalArgumentException(
                "File size exceeds limit: " + (maxSize / 1024 / 1024) + "MB"
            );
        }
    }

    /**
     * Validate file extension
     */
    private static void validateFileExtension(String extension, String fileType) {
        Set<String> allowedExtensions;
        if ("image".equals(fileType)) {
            allowedExtensions = ALLOWED_IMAGE_EXTENSIONS;
        } else if ("video".equals(fileType)) {
            allowedExtensions = ALLOWED_VIDEO_EXTENSIONS;
        } else {
            allowedExtensions = ALLOWED_DOC_EXTENSIONS;
        }

        if (!allowedExtensions.contains(extension)) {
            throw new IllegalArgumentException(
                "Invalid file type. Allowed: " + allowedExtensions
            );
        }
    }

    /**
     * Check if file is image
     */
    public static boolean isImage(String filename) {
        String extension = getFileExtension(filename);
        return ALLOWED_IMAGE_EXTENSIONS.contains(extension);
    }

    /**
     * Check if file is video
     */
    public static boolean isVideo(String filename) {
        String extension = getFileExtension(filename);
        return ALLOWED_VIDEO_EXTENSIONS.contains(extension);
    }

    /**
     * Get file size in readable format
     */
    public static String getReadableFileSize(long size) {
        if (size < 1024) {
            return size + " B";
        } else if (size < 1024 * 1024) {
            return String.format("%.2f KB", size / 1024.0);
        } else {
            return String.format("%.2f MB", size / 1024.0 / 1024.0);
        }
    }
}
