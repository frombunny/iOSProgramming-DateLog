package com.ios.datelog.global.external.s3;

import lombok.RequiredArgsConstructor;
import org.apache.tomcat.util.http.fileupload.FileUploadException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

import java.io.IOException;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class S3Service {
    private final S3Client s3Client;

    @Value("${spring.cloud.aws.s3.bucket}")
    private String bucketName;

    @Value("${spring.cloud.aws.region.static}")
    private String region;

    /**
     * 파일 업로드 후 url 반환
     */
    public String uploadFile(MultipartFile file) throws IOException {
        try {
            String key = generateFileKey(file.getOriginalFilename());

            PutObjectRequest putObjectRequest = PutObjectRequest.builder()
                    .bucket(bucketName)
                    .key(key)
                    .contentType(file.getContentType())
                    .build();

            s3Client.putObject(putObjectRequest, RequestBody.fromInputStream(file.getInputStream(), file.getSize()));
            return String.format("https://%s.s3.%s.amazonaws.com/%s", bucketName, region, key);
        }catch (IOException e) {
            throw new FileUploadException();
        }
    }

    /**
     * 파일 키 생성
     */
    public String generateFileKey(String fileName){
        // 파일명에서 확장자 추출
        String ext = Optional.ofNullable(fileName)
                .filter(n -> n.contains(".")) // '.' 포함 여부
                .map(n->n.substring(fileName.lastIndexOf('.'))) // 마지막 점부터 끝까지 -> 확장자
                .orElse(""); // 확장자가 없으면 빈 문자열

        return UUID.randomUUID()+ext;
    }
}
