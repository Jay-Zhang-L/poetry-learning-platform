import { defineStore } from 'pinia'

const KEY = 'shici_profile_v1'

export const useProfileStore = defineStore('profile', {
  state: () => ({
    role: '', // primary | junior | senior | lover
    nickname: '',
    goal: '每天学 10 分钟',
    userId: null,
  }),
  getters: {
    roleLabel: (s) =>
      ({ primary: '小学', junior: '初中', senior: '高中', lover: '爱好者' }[s.role] || '未选择'),
    displayName: (s) => s.nickname || '未登录',
    isReady: (s) => !!s.role,
    isLoggedIn: (s) => !!s.userId,
  },
  actions: {
    load() {
      try {
        const raw = localStorage.getItem(KEY)
        if (raw) Object.assign(this, JSON.parse(raw))
        
        // 从localStorage读取登录信息
        const userStr = localStorage.getItem('user')
        if (userStr) {
          const user = JSON.parse(userStr)
          this.userId = user.id
          this.nickname = user.nickname || user.username
        }
      } catch {}
    },
    save() {
      localStorage.setItem(KEY, JSON.stringify({ 
        role: this.role, 
        nickname: this.nickname, 
        goal: this.goal,
        userId: this.userId 
      }))
    },
    setUser(user) {
      this.userId = user.id
      this.nickname = user.nickname || user.username
      this.save()
    },
    setRole(role) { this.role = role; this.save() },
    setNickname(n) { this.nickname = (n || '墨墨').slice(0, 16); this.save() },
    setGoal(g) { this.goal = (g || '').slice(0, 32); this.save() },
    logout() {
      this.userId = null
      this.nickname = ''
      this.save()
    }
  },
})
