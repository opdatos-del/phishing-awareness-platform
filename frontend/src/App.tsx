import { useEffect, useState } from 'react'
import { Navigate, Route, Routes } from 'react-router'
import Login from './pages/Login'
import Layout from './pages/Layout'
import { LandingPages, Templates, Users } from './pages/AdminPages'
import Campaigns from './pages/Campaigns'
import CampaignDetail from './pages/CampaignDetail'
import Dashboard from './pages/Dashboard'
import RiskReport from './pages/RiskReport'
import Recipients from './pages/Recipients'

export default function App() {
  const [authenticated, setAuthenticated] = useState(Boolean(localStorage.getItem('paware.jwt')))
  useEffect(() => { const logout = () => setAuthenticated(false); window.addEventListener('paware:logout', logout); return () => window.removeEventListener('paware:logout', logout) }, [])
  return <Routes><Route path="/login" element={authenticated ? <Navigate to="/" replace /> : <Login onLogin={() => setAuthenticated(true)} />} />{authenticated ? <Route path="*" element={<Layout onLogout={() => setAuthenticated(false)}><Routes><Route path="/" element={<Dashboard />} /><Route path="/analytics" element={<RiskReport />} /><Route path="/campaigns" element={<Campaigns />} /><Route path="/campaigns/:id" element={<CampaignDetail />} /><Route path="/recipients" element={<Recipients />} /><Route path="/templates" element={<Templates />} /><Route path="/landing-pages" element={<LandingPages />} /><Route path="/users" element={<Users />} /><Route path="*" element={<Navigate to="/" replace />} /></Routes></Layout>} /> : <Route path="*" element={<Navigate to="/login" replace />} />}</Routes>
}
