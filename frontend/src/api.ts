import axios from 'axios'

export type Page<T> = { content: T[]; page: number; size: number; totalElements: number; totalPages: number }
export type Recipient = { id: number; name: string; email: string; active: boolean }
export type RecipientBatchResult = { successCount: number; createdCount: number; updatedCount: number; failedItems: { row: number; name: string; email: string; reason: string }[] }
export type Template = { id: number; name: string; description?: string; category: string; difficulty: string; subject: string; html: string; active: boolean }
export type LandingPage = { id: number; name: string; slug: string; category: string; difficulty: string; html: string; active: boolean }
export type Campaign = { id: number; name: string; description?: string; status: string; template: Template; landingPage: LandingPage; scheduledAt?: string; startedAt?: string; sentAt?: string; sendByAt?: string }
export type CampaignCard = { id: number; name: string; description?: string; status: string; templateName: string; landingPageName: string; createdAt: string; scheduledAt?: string; startedAt?: string; totalSent: number; totalOpened: number; totalClicked: number; totalSubmitted: number; totalTrainingCompleted: number }
export type CampaignRecipient = { id: number; recipientId: number; recipientName: string; recipientEmail: string; trackingToken: string; status: string; sentAt?: string; openedAt?: string; clickedAt?: string; landingViewedAt?: string; submittedAt?: string; reportedAt?: string; trainingViewedAt?: string; deliveredAt?: string; trainingCompletedAt?: string }
export type CampaignStats = { totalSent: number; totalOpened: number; totalClicked: number; totalSubmitted: number; totalReported: number; totalTrainingViewed: number; totalTrainingCompleted: number; openRate: number; clickRate: number; submitRate: number; trainingRate: number }
export type CampaignEvent = { id: number; type: string; eventTime: string; recipientName: string; recipientEmail: string }
export type TrendPoint = { date: string; submissions: number; trainingCompleted: number }
export type DomainRiskRow = { domain: string; people: number; submissions: number; submitRate: number; averageRiskScore: number }
export type PerformanceRow = { name: string; sent: number; opened: number; clicked: number; submitted: number; openRate: number; clickRate: number; submitRate: number }
export type AnalyticsInsights = { templates: PerformanceRow[]; landingPages: PerformanceRow[]; retestCandidates: { recipientId: number; name: string; email: string; submits: number; riskScore: number; lastSubmittedAt?: string }[]; timing: { openedCount: number; averageOpenMinutes: number; clickedCount: number; averageClickMinutes: number } }
export type Dashboard = { activeCampaigns: number; totalCampaigns: number; totalSent: number; totalOpened: number; totalClicked: number; totalSubmitted: number; totalReported: number; totalTrainingViewed: number; totalTrainingCompleted: number; recentCampaigns: { id: number; name: string; status: string; createdAt: string }[] }
export type AdminUser = { id: number; username: string; role: string; active: boolean }
export type RiskReportRow = { recipientId: number; name: string; email: string; campaignsReceived: number; opens: number; clicks: number; submits: number; reports: number; firstSubmittedAt?: string; lastSubmittedAt?: string; riskScore: number; riskLevel: 'BAJO' | 'MEDIO' | 'ALTO' | 'CRITICO' }

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
