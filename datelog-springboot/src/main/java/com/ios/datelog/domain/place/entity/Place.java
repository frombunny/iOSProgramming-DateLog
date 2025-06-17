package com.ios.datelog.domain.place.entity;

import com.ios.datelog.domain.place.entity.enums.Tag;
import com.ios.datelog.global.entity.BaseEntity;
import jakarta.persistence.*;
import lombok.*;

@Getter
@Builder
@AllArgsConstructor(access = AccessLevel.PROTECTED)
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity
@Table
public class Place extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    private String content;

    private String location;

    @Enumerated(EnumType.STRING)
    private Tag tag;

    private String image;
}
