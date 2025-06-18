package com.ios.datelog.domain.record.web.dto;

import com.ios.datelog.domain.record.entity.Datelog;

public record GetDatelogRes(
        Long id,
        String image,
        String title,
        String diary
) {
    public static GetDatelogRes from(Datelog datelog) {
        return new GetDatelogRes(datelog.getId(), datelog.getImage(), datelog.getTitle(), datelog.getDiary());
    }
}
