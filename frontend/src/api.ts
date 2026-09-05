import axios from 'axios'

export type Page<T> = { content: T[]; page: number; size: number; totalElements: number; totalPages: number }
export type Recipient = { id: number; name: string; email: string; active: boolean }
export type Template = { id: number; name: string; description?: string; category: string; difficulty: string; subject: string; html: string; active: boolean }
export type LandingPage = { id: number; name: string; slug: string; category: string; difficulty: string; html: string; active: boolean }
export type Campaign = { id: number; name: string; description?: string; status: string; template: Template; landingPage: LandingPage; scheduledAt?: string; startedAt?: string; sentAt?: string }
export type CampaignRecipient = { id: number; recipientId: number; recipientName: string; recipientEmail: string; trackingToken: string; status: string; sentAt?: string; openedAt?: string; clickedAt?: string; submittedAt?: string; reportedAt?: string; trainingViewedAt?: string; deliveredAt?: string; trainingCompletedAt?: string }
export type CampaignStats = { totalSent: number; totalOpened: number; totalClicked: number; totalSubmitted: number; totalReported: number; totalTrainingViewed: number; totalTrainingCompleted: number; openRate: number; clickRate: number; submitRate: number; trainingRate: number }
export type Dashboard = { activeCampaigns: number; totalCampaigns: number; totalSent: number; totalOpened: number; totalClicked: number; totalSubmitted: number; totalTrainingViewed: number; recentCampaigns: { id: number; name: string; status: string; createdAt: string }[] }
export type AdminUser = { id: number; username: string; role: string; active: boolean }

export const api = axios.create({ baseURL: import.meta.env.VITE_API_URL || '/api/v1' })

api.interceptors.request.use((config) => {
  const token = localStorage.getItem('paware.jwt')
  if (token) config.headers.Authorization = `Bearer ${token}`
  return config
})

api.interceptors.response.use(undefined, (error) => {
  if (error.response?.status === 401) {
    localStorage.removeItem('paware.jwt')
    window.dispatchEvent(new Event('paware:logout'))
  }
  return Promise.reject(error)
})
