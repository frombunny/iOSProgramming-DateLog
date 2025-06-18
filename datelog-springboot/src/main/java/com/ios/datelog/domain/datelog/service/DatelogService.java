package com.ios.datelog.domain.datelog.service;

import com.ios.datelog.domain.datelog.entity.Datelog;
import com.ios.datelog.domain.datelog.repository.DatelogRepository;
import com.ios.datelog.domain.datelog.web.dto.CreateDatelogReq;
import com.ios.datelog.domain.datelog.web.dto.GetDatelogRes;
import com.ios.datelog.domain.user.entity.User;
import com.ios.datelog.domain.user.exception.CanNotAccessException;
import com.ios.datelog.domain.user.repository.UserRepository;
import com.ios.datelog.global.auth.UserPrincipal;
import com.ios.datelog.global.external.s3.S3Service;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

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

    public GetDatelogRes getDatelog(UserPrincipal userPrincipal, Long datelogId) {
        User user = userRepository.getUserById(userPrincipal.getId());
        Datelog datelog = datelogRepository.getDatelogById(datelogId);

        if(datelog.getUser()!=user) throw new CanNotAccessException();
        return GetDatelogRes.from(datelog);
    }

    public List<GetDatelogRes> getAllDatelogs(UserPrincipal userPrincipal) {
        User user = userRepository.getUserById(userPrincipal.getId());

        return datelogRepository.findAllByUser(user).stream()
                .map(GetDatelogRes::from)
                .collect(Collectors.toList());
    }
}
