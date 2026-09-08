import { useMemo, useState } from 'react'
import { Link, useParams } from 'react-router'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { api } from '../api'
import type { Campaign, CampaignEvent, CampaignRecipient, CampaignStats, Page, Recipient } from '../api'
import { Button, CampaignStatusBadge, errorText, PageTitle, StatCard } from '../components/ui'
import { DataTable } from '../components/DataTable'
import { CampaignStepper, EventTimeline, Funnel } from '../components/OperationsVisuals'
import { ErrorState, Skeleton } from '../components/States'

const statusLabel: Record<string, string> = { PENDING: 'Pendiente', EMAIL_SENT: 'Enviado', EMAIL_DELIVERED: 'Entregado', EMAIL_OPENED: 'Abierto', LINK_CLICKED: 'Clic', LANDING_VIEWED: 'Landing vista', FORM_SUBMITTED: 'Formulario enviado', TRAINING_VIEWED: 'Formación vista', TRAINING_COMPLETED: 'Formación completada' }
const emptyStats: CampaignStats = { totalSent: 0, totalOpened: 0, totalClicked: 0, totalSubmitted: 0, totalReported: 0, totalTrainingViewed: 0, totalTrainingCompleted: 0, openRate: 0, clickRate: 0, submitRate: 0, trainingRate: 0 }

function Preview({ campaign }: { campaign: Campaign }) {
  const [view, setView] = useState<'email' | 'landing'>('email')
  const html = view === 'email' ? campaign.template.html : campaign.landingPage.html
  return <section className="rounded-2xl border border-slate-200 bg-white p-6">
    <div className="flex flex-wrap items-start justify-between gap-4"><div><p className="text-xs font-bold uppercase tracking-[.15em] text-[#d95d39]">Material enviado</p><h2 className="mt-1 font-serif text-2xl">Vista previa de campaña</h2></div><div className="flex rounded-lg border border-slate-200 p-1"><button type="button" onClick={() => setView('email')} className={`rounded-md px-3 py-1.5 text-sm font-semibold ${view === 'email' ? 'bg-[#102a43] text-white' : 'text-slate-600'}`}>Email</button><button type="button" onClick={() => setView('landing')} className={`rounded-md px-3 py-1.5 text-sm font-semibold ${view === 'landing' ? 'bg-[#102a43] text-white' : 'text-slate-600'}`}>Landing</button></div></div>
    <p className="mt-3 text-sm text-slate-500">{view === 'email' ? campaign.template.name : campaign.landingPage.name} · contenido aislado, sin enviar ni registrar eventos.</p>
    <iframe title={`Vista previa ${view === 'email' ? 'del email' : 'de la landing'}`} sandbox="" srcDoc={html} className="mt-5 h-[30rem] w-full rounded-xl border border-slate-200 bg-white" />
  </section>
}

export default function CampaignDetail() {
  const { id } = useParams()
  const client = useQueryClient()
  const [selected, setSelected] = useState<number[]>([])
  const [schedule, setSchedule] = useState('')
  const [durationMinutes, setDurationMinutes] = useState('80')
  const campaign = useQuery<Campaign>({ queryKey: ['campaign', id], queryFn: () => api.get(`/campaigns/${id}`).then(response => response.data) })
  const recipients = useQuery<CampaignRecipient[]>({ queryKey: ['campaign-recipients', id], queryFn: () => api.get(`/campaigns/${id}/recipients`).then(response => response.data) })
  const stats = useQuery<CampaignStats>({ queryKey: ['campaign-stats', id], queryFn: () => api.get(`/campaigns/${id}/stats`).then(response => response.data) })
  const events = useQuery<CampaignEvent[]>({ queryKey: ['campaign-events', id], queryFn: () => api.get(`/campaigns/${id}/events`).then(response => response.data) })
  const audience = useQuery<Page<Recipient>>({ queryKey: ['all-recipients'], queryFn: () => api.get('/recipients', { params: { size: 1000 } }).then(response => response.data) })
  const add = useMutation({ mutationFn: () => api.post(`/campaigns/${id}/recipients`, { recipientIds: selected }), onSuccess: () => { client.invalidateQueries({ queryKey: ['campaign-recipients', id] }); setSelected([]) } })
  const launch = useMutation({ mutationFn: () => api.post(`/campaigns/${id}/launch`, { ...(schedule ? { scheduledAt: schedule } : {}), ...(durationMinutes ? { durationMinutes: Number(durationMinutes) } : {}) }), onSuccess: () => { client.invalidateQueries({ queryKey: ['campaign', id] }); client.invalidateQueries({ queryKey: ['campaign-recipients', id] }); client.invalidateQueries({ queryKey: ['campaign-stats', id] }); client.invalidateQueries({ queryKey: ['campaign-cards'] }) } })
  const eventsByEmail = useMemo(() => { const grouped: Record<string, CampaignEvent[]> = {}; (events.data || []).forEach(event => { (grouped[event.recipientEmail] ||= []).push(event) }); return grouped }, [events.data])
  const exportCsv = () => { const csv = [['Nombre', 'Email', 'Estado'], ...(recipients.data || []).map(row => [row.recipientName, row.recipientEmail, row.status])].map(row => row.map(value => `"${String(value).replaceAll('"', '""')}"`).join(',')).join('\n'); const url = URL.createObjectURL(new Blob([csv], { type: 'text/csv;charset=utf-8' })); const link = document.createElement('a'); link.href = url; link.download = `campana-${id}-resultados.csv`; link.click(); URL.revokeObjectURL(url) }

  const available = (audience.data?.content || []).filter(row => row.active && !recipients.data?.some(associated => associated.recipientId === row.id))
  const allSelected = available.length > 0 && available.every(row => selected.includes(row.id))
  const duration = Number(durationMinutes)
  const sendRate = duration && recipients.data?.length ? recipients.data.length / duration : 0
  if (campaign.isLoading) return <Skeleton />
  if (campaign.error || !campaign.data) return <ErrorState error={campaign.error} retry={() => campaign.refetch()} />
  const current = campaign.data
  const currentStats = stats.data || emptyStats

  return <>
    <PageTitle eyebrow="Detalle de campaña" title={current.name} action={<div className="flex flex-wrap gap-2"><Link to="/campaigns"><Button variant="muted">Volver</Button></Link><Button variant="muted" onClick={exportCsv} disabled={!recipients.data?.length}>Exportar CSV</Button>{current.status === 'DRAFT' ? <Button onClick={() => launch.mutate()} disabled={launch.isPending}>Lanzar</Button> : null}</div>} />
    <section className="mb-6 rounded-2xl border border-slate-200 bg-white p-5"><div className="flex flex-wrap items-center justify-between gap-3"><CampaignStepper status={current.status} /><CampaignStatusBadge status={current.status} /></div><p className="mt-3 text-sm text-slate-600">{current.description || 'Sin descripción.'}</p></section>
    <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4"><StatCard label="Tasa de apertura" value={`${currentStats.openRate}%`} note={`${currentStats.totalOpened} de ${currentStats.totalSent} enviados`} /><StatCard label="Tasa de clics" value={`${currentStats.clickRate}%`} note={`${currentStats.totalClicked} de ${currentStats.totalSent} enviados`} /><StatCard label="Tasa de envío" value={`${currentStats.submitRate}%`} note={`${currentStats.totalSubmitted} de ${currentStats.totalSent} enviados`} /><StatCard label="Tasa de formación" value={`${currentStats.trainingRate}%`} note={`${currentStats.totalTrainingCompleted} de ${currentStats.totalSent} enviados`} /></div>
    {stats.error ? <p className="mt-4 text-sm text-red-700">No se pudo cargar métricas de campaña.</p> : <div className="mt-6"><Funnel stats={currentStats} /></div>}
    {launch.error ? <p className="mt-5 rounded-lg bg-red-50 p-3 text-sm text-red-700">{errorText(launch.error)}</p> : null}
    {current.status === 'DRAFT' ? <section className="mt-6 rounded-2xl border border-orange-100 bg-orange-50 p-6"><h2 className="font-serif text-2xl">Configuración de lanzamiento</h2><p className="mt-2 text-sm text-slate-600">Añade destinatarios. El reparto evita lanzar todos los correos al mismo tiempo.</p><div className="mt-4 grid gap-4 sm:grid-cols-2"><label className="grid gap-1 text-sm font-semibold"><span>Programación</span><input type="datetime-local" value={schedule} onChange={event => setSchedule(event.target.value)} className="rounded-lg border border-slate-200 bg-white px-3 py-2 font-normal" /></label><label className="grid gap-1 text-sm font-semibold"><span>Completar envíos en</span><select value={durationMinutes} onChange={event => setDurationMinutes(event.target.value)} className="rounded-lg border border-slate-200 bg-white px-3 py-2 font-normal"><option value="">Enviar de golpe</option><option value="15">15 minutos</option><option value="30">30 minutos</option><option value="60">60 minutos</option><option value="80">80 minutos</option></select></label></div>{duration && recipients.data?.length ? <p className="mt-4 rounded-lg bg-white/80 p-3 text-sm text-slate-700">GoPhish repartirá {recipients.data.length} correos en {duration} minutos: promedio aproximado de {sendRate.toFixed(1)} correos por minuto.</p> : <p className="mt-4 text-sm text-amber-800">Enviar de golpe puede activar límites o filtros del relay.</p>}</section> : null}
    <div className="mt-6 grid gap-6 xl:grid-cols-[.65fr_1.35fr]">
      <section className="rounded-2xl border border-slate-200 bg-white p-6"><h2 className="font-serif text-2xl">Añadir destinatarios</h2><div className="mt-4 flex items-center justify-between"><span className="text-sm text-slate-500">{available.length} disponibles</span><Button variant="muted" disabled={!available.length || current.status !== 'DRAFT'} onClick={() => setSelected(allSelected ? [] : available.map(row => row.id))}>{allSelected ? 'Quitar selección' : 'Seleccionar todos'}</Button></div><div className="mt-2 max-h-72 space-y-2 overflow-y-auto">{available.map(row => <label key={row.id} className="flex items-center gap-3 rounded-lg p-2 text-sm hover:bg-slate-50"><input type="checkbox" checked={selected.includes(row.id)} onChange={event => setSelected(event.target.checked ? [...selected, row.id] : selected.filter(value => value !== row.id))} /><span><b>{row.name}</b><span className="ml-2 text-slate-400">{row.email}</span></span></label>)}</div><Button variant="muted" className="mt-4" disabled={!selected.length || current.status !== 'DRAFT' || add.isPending} onClick={() => add.mutate()}>Asociar seleccionados</Button>{add.error ? <p className="mt-3 text-sm text-red-700">{errorText(add.error)}</p> : null}</section>
      <section><div className="mb-4 flex items-end justify-between"><div><p className="text-xs font-bold uppercase tracking-[.15em] text-[#d95d39]">Seguimiento</p><h2 className="font-serif text-2xl">Destinatarios y eventos</h2></div><span className="text-sm text-slate-500">{recipients.data?.length || 0} personas</span></div>{recipients.isLoading ? <Skeleton cards={1} /> : recipients.error ? <ErrorState error={recipients.error} retry={() => recipients.refetch()} /> : <DataTable rows={recipients.data || []} searchKeys={[row => row.recipientName, row => row.recipientEmail]} emptyText="No hay destinatarios asociados." expanded={row => <EventTimeline events={eventsByEmail[row.recipientEmail] || []} />} columns={[{ key: 'recipient', label: 'Destinatario', value: row => row.recipientName, render: row => <><b>{row.recipientName}</b><br /><span className="text-xs text-slate-500">{row.recipientEmail}</span></> }, { key: 'status', label: 'Etapa', value: row => row.status, render: row => <span className="rounded-full bg-orange-50 px-2 py-1 text-xs font-bold text-[#d95d39]">{statusLabel[row.status] || row.status}</span> }, { key: 'sent', label: 'Enviado', value: row => row.sentAt || '', render: row => row.sentAt ? new Date(row.sentAt).toLocaleString('es-MX') : '—' }]} />}</section>
    </div>
    <div className="mt-6"><Preview campaign={current} /></div>
  </>
}
