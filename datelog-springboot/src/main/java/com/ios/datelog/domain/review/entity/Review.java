package com.ios.datelog.domain.review.entity;

import com.ios.datelog.domain.place.entity.Place;
import com.ios.datelog.domain.review.web.dto.CreateReviewReq;
import com.ios.datelog.domain.user.entity.User;
import com.ios.datelog.global.entity.BaseEntity;
import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@Builder
@AllArgsConstructor(access = AccessLevel.PROTECTED)
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity
@Table(name = "review")
public class Review extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "place_id")
    private Place place;

    private String content;

    public static Review toEntity(User user, Place place, CreateReviewReq createReviewReq) {
        return Review.builder()
                .user(user)
                .place(place)
                .content(createReviewReq.content())
                .build();
    }
}
