package com.shici.controller;

import com.shici.common.R;
import com.shici.domain.dto.map.*;
import com.shici.service.PoetryMapService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;

/**
 * 诗词地图控制器
 */
@RestController
@RequestMapping("/api/poetry-map")
@RequiredArgsConstructor
@CrossOrigin
public class PoetryMapController {

    private final PoetryMapService poetryMapService;

    /**
     * 获取诗词地图概览数据
     * 接口：GET /api/poetry-map/overview
     */
    @GetMapping("/overview")
    public R<MapOverviewResponse> getOverview(
            @RequestParam(required = false) String dynasty,
            @RequestParam(required = false) BigDecimal minHeat) {
        MapOverviewResponse response = poetryMapService.getOverview(dynasty, minHeat);
        return R.ok(response);
    }

    /**
     * 获取地点详情
     * 接口：GET /api/poetry-map/location/{id}
     */
    @GetMapping("/location/{id}")
    public R<LocationDetailResponse> getLocationDetail(@PathVariable Long id) {
        LocationDetailResponse response = poetryMapService.getLocationDetail(id);
        if (response == null) {
            return R.fail("地点不存在");
        }
        return R.ok(response);
    }

    /**
     * 获取诗人路线
     * 接口：GET /api/poetry-map/poet/{id}/route
     */
    @GetMapping("/poet/{id}/route")
    public R<PoetRouteResponse> getPoetRoute(@PathVariable Long id) {
        PoetRouteResponse response = poetryMapService.getPoetRoute(id);
        if (response == null) {
            return R.fail("诗人不存在");
        }
        return R.ok(response);
    }

    /**
     * 获取诗人关系网
     * 接口：GET /api/poetry-map/poet/{id}/relationships
     */
    @GetMapping("/poet/{id}/relationships")
    public R<PoetRelationshipResponse> getPoetRelationships(@PathVariable Long id) {
        PoetRelationshipResponse response = poetryMapService.getPoetRelationships(id);
        return R.ok(response);
    }

    /**
     * 获取时间轴数据
     * 接口：GET /api/poetry-map/timeline/{poetId}
     */
    @GetMapping("/timeline/{poetId}")
    public R<TimelineResponse> getTimeline(@PathVariable Long poetId) {
        TimelineResponse response = poetryMapService.getTimeline(poetId);
        if (response == null) {
            return R.fail("诗人不存在");
        }
        return R.ok(response);
    }

    /**
     * 获取典故列表
     * 接口：GET /api/poetry-map/location/{id}/allusions
     */
    @GetMapping("/location/{id}/allusions")
    public R<AllusionListResponse> getAllusions(@PathVariable Long id) {
        AllusionListResponse response = poetryMapService.getAllusions(id);
        if (response == null) {
            return R.fail("地点不存在");
        }
        return R.ok(response);
    }

    /**
     * 获取所有省份列表
     * 接口：GET /api/poetry-map/provinces
     */
    @GetMapping("/provinces")
    public R<List<ProvinceDto>> getAllProvinces() {
        List<ProvinceDto> provinces = poetryMapService.getAllProvinces();
        return R.ok(provinces);
    }

    /**
     * 获取省份详情
     * 接口：GET /api/poetry-map/province/{id}
     */
    @GetMapping("/province/{id}")
    public R<ProvinceDetailResponse> getProvinceDetail(@PathVariable Long id) {
        ProvinceDetailResponse response = poetryMapService.getProvinceDetail(id);
        if (response == null) {
            return R.fail("省份不存在");
        }
        return R.ok(response);
    }
}
