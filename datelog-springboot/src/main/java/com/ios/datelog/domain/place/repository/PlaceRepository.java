package com.ios.datelog.domain.place.repository;

import com.ios.datelog.domain.place.entity.Place;
import com.ios.datelog.domain.place.entity.enums.Tag;
import com.ios.datelog.domain.place.exception.PlaceNotFoundException;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PlaceRepository extends JpaRepository<Place, Long> {
    List<Place> findAllByTagAndNameContainingIgnoreCase(Tag tag, String keyword);
    List<Place> findAllByIdIn(List<Long> ids);

    @Query(value = "SELECT * FROM place ORDER BY RAND() LIMIT 5", nativeQuery = true)
    List<Place> findRandomFivePlaces();

    default Place getPlaceById(Long id) {
        return this.findById(id).orElseThrow(PlaceNotFoundException::new);
    }
}
