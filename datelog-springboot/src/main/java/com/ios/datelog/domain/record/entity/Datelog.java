package com.ios.datelog.domain.record.entity;

import com.ios.datelog.domain.record.web.dto.CreateDatelogReq;
import com.ios.datelog.domain.user.entity.User;
import com.ios.datelog.global.entity.BaseEntity;
import jakarta.persistence.*;
import lombok.*;

@Getter
@AllArgsConstructor(access = AccessLevel.PROTECTED)
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Builder
@Entity
@Table(name = "datelog")
public class Datelog extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    private String title;

    private String diary;

    private String image;

    private String location;

    public static Datelog toEntity(CreateDatelogReq createRecordReq, User user, String imgUrl) {
        return Datelog.builder()
                .diary(createRecordReq.diary())
                .user(user)
                .title(createRecordReq.title())
                .image(imgUrl)
                .location(createRecordReq.location())
                .build();
    }
}
