import { Routes, Route, Link } from 'react-router-dom'

function Dashboard() {
  return (
    <div className="p-8">
      <h1 className="text-3xl font-bold mb-4">Phishing Awareness Platform</h1>
      <p className="text-gray-600 mb-8">
        Internal phishing simulation platform for employee security awareness.
      </p>
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <Link to="/campaigns" className="p-6 bg-white rounded-lg shadow hover:shadow-md transition">
          <h2 className="text-xl font-semibold">Campaigns</h2>
          <p className="text-gray-500">Manage phishing simulations</p>
        </Link>
        <Link to="/recipients" className="p-6 bg-white rounded-lg shadow hover:shadow-md transition">
          <h2 className="text-xl font-semibold">Recipients</h2>
          <p className="text-gray-500">Manage employee contacts</p>
        </Link>
        <Link to="/templates" className="p-6 bg-white rounded-lg shadow hover:shadow-md transition">
          <h2 className="text-xl font-semibold">Templates</h2>
          <p className="text-gray-500">Email and landing page templates</p>
        </Link>
      </div>
    </div>
  )
}

function Campaigns() {
  return (
    <div className="p-8">
      <h1 className="text-2xl font-bold mb-4">Campaigns</h1>
      <p className="text-gray-600">Coming soon in Phase 4.</p>
    </div>
  )
}

function Recipients() {
  return (
    <div className="p-8">
      <h1 className="text-2xl font-bold mb-4">Recipients</h1>
      <p className="text-gray-600">Coming soon in Phase 4.</p>
    </div>
  )
}

function Templates() {
  return (
    <div className="p-8">
      <h1 className="text-2xl font-bold mb-4">Templates</h1>
      <p className="text-gray-600">Coming soon in Phase 5.</p>
    </div>
  )
}

export default function App() {
  return (
    <div className="min-h-screen bg-gray-50">
      <Routes>
        <Route path="/" element={<Dashboard />} />
        <Route path="/campaigns" element={<Campaigns />} />
        <Route path="/recipients" element={<Recipients />} />
        <Route path="/templates" element={<Templates />} />
      </Routes>
    </div>
  )
}
