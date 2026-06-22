import { defineStore } from 'pinia'

export const useFollowRelationsStore = defineStore('followRelations', {
  state: () => ({
    following: [], // 关注列表
    followers: [], // 粉丝列表
    mutualFollowing: [] // 互关列表
  }),

  getters: {
    // 判断是否关注了某个用户
    isFollowing: (state) => (userId) => {
      return state.following.some(f => f.id === userId || f.followingId === userId)
    },

    // 判断是否互关（兼容前端调用）
    isMutualFollow: (state) => (userId) => {
      return state.mutualFollowing.some(f => f.id === userId)
    },

    // 判断是否互关（标准命名）
    isMutualFollowing: (state) => (userId) => {
      return state.mutualFollowing.some(f => f.id === userId)
    },

    // 获取关注数量
    followingCount: (state) => state.following.length,

    // 获取粉丝数量
    followerCount: (state) => state.followers.length
  },

  actions: {
    // 从API初始化数据
    initFromAPI(data) {
      this.following = data.following || []
      this.followers = data.followers || []

      // 计算互关列表
      this.calculateMutualFollowing()
    },

    // 计算互关用户
    calculateMutualFollowing() {
      const followingIds = new Set()
      this.following.forEach(f => {
        const id = f.id || f.followingId
        if (id) followingIds.add(id)
      })

      this.mutualFollowing = this.followers.filter(f => {
        const id = f.id || f.followerId
        return id && followingIds.has(id)
      })
    },

    // 添加关注（支持用户对象或用户ID）
    addFollowing(userOrId) {
      // 如果传的是ID，创建一个简单的用户对象
      if (typeof userOrId === 'number' || typeof userOrId === 'string') {
        this.following.push({ id: userOrId })
      } else {
        this.following.push(userOrId)
      }
      this.calculateMutualFollowing()
    },

    // 取消关注
    removeFollowing(userId) {
      this.following = this.following.filter(f => {
        const id = f.id || f.followingId
        return id !== userId
      })
      this.calculateMutualFollowing()
    },

    // 添加粉丝
    addFollower(user) {
      this.followers.push(user)
      this.calculateMutualFollowing()
    },

    // 移除粉丝
    removeFollower(userId) {
      this.followers = this.followers.filter(f => {
        const id = f.id || f.followerId
        return id !== userId
      })
      this.calculateMutualFollowing()
    },

    // 清空所有数据
    clear() {
      this.following = []
      this.followers = []
      this.mutualFollowing = []
    }
  }
})
