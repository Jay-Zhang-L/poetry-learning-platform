package com.shici.service;

import com.shici.domain.dto.map.*;
import com.shici.mapper.PoetryMapMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.*;

/**
 * 诗词地图服务层
 */
@Service
@RequiredArgsConstructor
public class PoetryMapService {

    private final PoetryMapMapper poetryMapMapper;

    /**
     * 获取地图概览数据
     */
    public MapOverviewResponse getOverview(String dynasty, BigDecimal minHeat) {
        // 获取地点热度数据
        List<LocationHeatDto> locations = poetryMapMapper.getLocationHeatData(dynasty, minHeat);
        
        // 为每个地点获取著名诗人
        for (LocationHeatDto location : locations) {
            List<String> famousPoets = poetryMapMapper.getFamousPoetsByLocation(
                    location.getId(), dynasty, 5);
            location.setFamousPoets(famousPoets);
        }

        // 计算热度范围
        HeatRange heatRange = new HeatRange();
        if (!locations.isEmpty()) {
            BigDecimal min = locations.stream()
                    .map(LocationHeatDto::getHeatValue)
                    .min(BigDecimal::compareTo)
                    .orElse(BigDecimal.ZERO);
            BigDecimal max = locations.stream()
                    .map(LocationHeatDto::getHeatValue)
                    .max(BigDecimal::compareTo)
                    .orElse(BigDecimal.ZERO);
            heatRange.setMin(min);
            heatRange.setMax(max);
        } else {
            heatRange.setMin(BigDecimal.ZERO);
            heatRange.setMax(BigDecimal.ZERO);
        }

        // 获取全部诗人列表
        List<RepresentativePoetDto> allPoets = poetryMapMapper.getAllPoets();

        MapOverviewResponse response = new MapOverviewResponse();
        response.setLocations(locations);
        response.setHeatRange(heatRange);
        response.setPoets(allPoets);
        return response;
    }

    /**
     * 获取地点详情
     */
    public LocationDetailResponse getLocationDetail(Long id) {
        // 获取地点基本信息
        LocationDetailResponse location = poetryMapMapper.getLocationById(id);
        if (location == null) {
            return null;
        }

        // 获取代表诗人
        List<RepresentativePoetDto> poets = poetryMapMapper.getRepresentativePoets(id);
        location.setRepresentativePoets(poets);

        // 获取典故
        List<AllusionDto> allusions = poetryMapMapper.getAllusionsByLocationId(id);
        location.setAllusions(allusions);

        // 获取诗词统计
        List<DynastyStatDto> dynastyStats = poetryMapMapper.getPoemStatsByLocation(id);
        PoemStatsDto poemStats = new PoemStatsDto();
        int total = 0;
        Map<String, Integer> byDynasty = new HashMap<>();
        for (DynastyStatDto stat : dynastyStats) {
            total += stat.getCount();
            byDynasty.put(stat.getDynasty(), stat.getCount());
        }
        poemStats.setTotal(total);
        poemStats.setByDynasty(byDynasty);
        location.setPoemStats(poemStats);

        return location;
    }

    /**
     * 获取诗人路线
     */
    public PoetRouteResponse getPoetRoute(Long poetId) {
        // 获取诗人信息
        PoetInfoDto poet = poetryMapMapper.getPoetInfoById(poetId);
        if (poet == null) {
            return null;
        }

        // 获取路线
        List<RoutePointDto> route = poetryMapMapper.getPoetRoute(poetId);
        
        // 为每个路线点获取诗词
        for (RoutePointDto point : route) {
            List<RoutePoemDto> poems = poetryMapMapper.getPoemsByPoetAndLocation(
                    poetId, point.getLocationId());
            point.setPoems(poems);
        }

        PoetRouteResponse response = new PoetRouteResponse();
        response.setPoet(poet);
        response.setRoute(route);
        return response;
    }

    /**
     * 获取诗人关系网
     */
    public PoetRelationshipResponse getPoetRelationships(Long poetId) {
        // 获取节点
        List<RelationNodeDto> nodes = poetryMapMapper.getRelationNodes(poetId);
        
        // 获取边
        List<RelationEdgeDto> edges = poetryMapMapper.getRelationEdges(poetId);

        PoetRelationshipResponse response = new PoetRelationshipResponse();
        response.setNodes(nodes);
        response.setEdges(edges);
        return response;
    }

    /**
     * 获取时间轴数据
     */
    public TimelineResponse getTimeline(Long poetId) {
        // 获取诗人信息
        PoetInfoDto poet = poetryMapMapper.getPoetInfoById(poetId);
        if (poet == null) {
            return null;
        }

        // 获取时间轴事件
        List<TimelineEventDto> events = poetryMapMapper.getTimelineEvents(poetId);

        TimelineResponse response = new TimelineResponse();
        response.setPoet(poet);
        response.setEvents(events);
        return response;
    }

    /**
     * 获取典故列表
     */
    public AllusionListResponse getAllusions(Long locationId) {
        // 获取地点名称
        String locationName = poetryMapMapper.getLocationName(locationId);
        if (locationName == null) {
            return null;
        }

        // 获取典故详情
        List<AllusionDetailDto> allusions = poetryMapMapper.getAllusionDetailsByLocation(locationId);
        
        // 为每个典故获取相关诗词
        for (AllusionDetailDto allusion : allusions) {
            List<RelatedPoemDto> relatedPoems = poetryMapMapper.getRelatedPoemsByAllusion(allusion.getId());
            allusion.setRelatedPoems(relatedPoems);
        }

        AllusionListResponse response = new AllusionListResponse();
        response.setLocation(locationName);
        response.setAllusions(allusions);
        return response;
    }

    /**
     * 获取所有省份列表
     */
    public List<ProvinceDto> getAllProvinces() {
        return poetryMapMapper.getAllProvinces();
    }

    /**
     * 获取省份详情
     */
    public ProvinceDetailResponse getProvinceDetail(Long id) {
        return poetryMapMapper.getProvinceById(id);
    }
}
