package com.ios.datelog.domain.record.service;

import com.ios.datelog.domain.record.entity.Datelog;
import com.ios.datelog.domain.record.repository.DatelogRepository;
import com.ios.datelog.domain.record.web.dto.CreateDatelogReq;
import com.ios.datelog.domain.user.entity.User;
import com.ios.datelog.domain.user.repository.UserRepository;
import com.ios.datelog.global.auth.UserPrincipal;
import com.ios.datelog.global.external.s3.S3Service;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;

@Service
@RequiredArgsConstructor
public class DatelogService {
    private final UserRepository userRepository;
    private final DatelogRepository datelogRepository;
    private final S3Service s3Service;

    @Transactional
    public void createRecord(CreateDatelogReq createRecordReq, UserPrincipal userPrincipal) throws IOException {
        User user = userRepository.getUserById(userPrincipal.getId());

        String imgUrl = s3Service.uploadFile(createRecordReq.image());
        Datelog datelog = Datelog.toEntity(createRecordReq, user, imgUrl);
        datelogRepository.save(datelog);
    }
}
