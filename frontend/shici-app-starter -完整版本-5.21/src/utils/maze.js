import request from '@/utils/request'

export function getMazeLevels(seasonNo = 1) {
  return request({
    url: '/api/game/maze/levels',
    method: 'get',
    params: { seasonNo }
  })
}

export function getMazeLevel(seasonNo = 1, levelNo) {
  return request({
    url: '/api/game/maze/level',
    method: 'get',
    params: { seasonNo, levelNo }
  })
}

export function getMazeProgress(seasonNo = 1, levelNo) {
  return request({
    url: '/api/game/maze/progress',
    method: 'get',
    params: { seasonNo, levelNo }
  })
}

export function submitMazeLine(data) {
  return request({
    url: '/api/game/maze/submit-line',
    method: 'post',
    data
  })
}

export function getMazeRank(seasonNo = 1) {
  return request({
    url: '/api/game/maze/rank',
    method: 'get',
    params: { seasonNo }
  })
}