package com.ios.datelog.domain.place.repository;

import com.ios.datelog.domain.place.entity.Place;
import com.ios.datelog.domain.place.entity.enums.Tag;
import com.ios.datelog.domain.place.exception.PlaceNotFoundException;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PlaceRepository extends JpaRepository<Place, Long> {
    @Query("SELECT p FROM Place p WHERE (:tag IS NULL OR p.tag = :tag) AND (:keyword IS NULL OR LOWER(p.name) LIKE LOWER(CONCAT('%', :keyword, '%')))")
    List<Place> findPlacesByTagAndKeyword(@Param("tag") Tag tag, @Param("keyword") String keyword);


    @Query(value = "SELECT * FROM place ORDER BY RAND() LIMIT 5", nativeQuery = true)
    List<Place> findRandomFivePlaces();

    default Place getPlaceById(Long id) {
        return this.findById(id).orElseThrow(PlaceNotFoundException::new);
    }
}
