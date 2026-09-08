import { Link } from 'react-router'
import { useState } from 'react'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { api } from '../api'
import type { CampaignCard, LandingPage, Page, Template } from '../api'
import { Button, CampaignStatusBadge, DeleteButton, Empty, errorText, Field, PageTitle, SelectField } from '../components/ui'
import { ErrorState, Skeleton } from '../components/States'

function Metric({ label, value, total }: { label: string; value: number; total: number }) {
  const percent = total ? Math.round(value * 100 / total) : 0
  return <div className="min-w-24"><div className="flex justify-between gap-2 text-xs text-slate-500"><span>{label}</span><b className="text-slate-700">{value}/{total}</b></div><div className="mt-1.5 h-1.5 overflow-hidden rounded-full bg-slate-100"><div className="h-full rounded-full bg-[#d95d39]" style={{ width: `${percent}%` }} /></div><p className="mt-1 text-xs font-semibold text-[#102a43]">{percent}%</p></div>
}

function CampaignCard({ campaign, onDelete, deleting }: { campaign: CampaignCard; onDelete: () => void; deleting: boolean }) {
  const schedule = campaign.scheduledAt ? new Date(campaign.scheduledAt).toLocaleString('es-MX') : null
  const created = new Date(campaign.createdAt).toLocaleDateString('es-MX')
  return <article className="rounded-2xl border border-slate-200 bg-white p-6 transition hover:border-[#d95d39] hover:shadow-md"><div className="flex flex-wrap items-start justify-between gap-4"><Link to={`/campaigns/${campaign.id}`} className="min-w-0 flex-1"><h2 className="font-serif text-2xl text-[#102a43]">{campaign.name}</h2><p className="mt-2 text-sm text-slate-500">{campaign.templateName} <span className="px-1">/</span> {campaign.landingPageName}</p></Link><div className="flex items-center gap-2"><CampaignStatusBadge status={campaign.status} />{campaign.status === 'DRAFT' ? <DeleteButton label={campaign.name} disabled={deleting} onDelete={onDelete} /> : null}</div></div>{schedule ? <p className="mt-4 inline-flex rounded-lg bg-blue-50 px-3 py-2 text-sm font-semibold text-blue-800">Programada para {schedule}</p> : <p className="mt-4 text-sm text-slate-500">{campaign.startedAt ? `Lanzada ${new Date(campaign.startedAt).toLocaleString('es-MX')}` : `Borrador creado ${created}`}</p>}<div className="mt-5 grid gap-4 border-t border-slate-100 pt-4 sm:grid-cols-3"><Metric label="Abiertos" value={campaign.totalOpened} total={campaign.totalSent} /><Metric label="Clics" value={campaign.totalClicked} total={campaign.totalSent} /><Metric label="Formación" value={campaign.totalTrainingCompleted} total={campaign.totalSent} /></div><Link to={`/campaigns/${campaign.id}`} className="mt-5 inline-block text-sm font-bold text-[#d95d39] hover:underline">Ver operación →</Link></article>
}

export default function Campaigns() {
  const client = useQueryClient()
  const [creating, setCreating] = useState(false)
  const [form, setForm] = useState({ name: '', description: '', templateId: '', landingPageId: '' })
  const campaigns = useQuery<Page<CampaignCard>>({ queryKey: ['campaign-cards'], queryFn: () => api.get('/campaigns/cards', { params: { size: 50 } }).then(response => response.data) })
  const templates = useQuery<Template[]>({ queryKey: ['templates'], queryFn: () => api.get('/templates').then(response => response.data) })
  const landings = useQuery<LandingPage[]>({ queryKey: ['landing-pages'], queryFn: () => api.get('/landing-pages').then(response => response.data) })
  const invalidate = () => { client.invalidateQueries({ queryKey: ['campaign-cards'] }); client.invalidateQueries({ queryKey: ['campaigns'] }); client.invalidateQueries({ queryKey: ['dashboard'] }) }
  const remove = useMutation({ mutationFn: (id: number) => api.delete(`/campaigns/${id}`), onSuccess: invalidate })
  const save = useMutation({ mutationFn: () => api.post('/campaigns', { ...form, templateId: Number(form.templateId), landingPageId: Number(form.landingPageId) }), onSuccess: () => { invalidate(); setCreating(false); setForm({ name: '', description: '', templateId: '', landingPageId: '' }) } })

  return <><PageTitle eyebrow="Operación" title="Campañas" action={<Button onClick={() => setCreating(value => !value)}>{creating ? 'Cerrar' : 'Nueva campaña'}</Button>} />{creating ? <form onSubmit={event => { event.preventDefault(); save.mutate() }} className="mb-6 rounded-2xl border border-orange-100 bg-orange-50 p-6"><div className="grid gap-4 md:grid-cols-2"><Field label="Nombre" value={form.name} onChange={event => setForm({ ...form, name: event.target.value })} required /><Field label="Descripción" value={form.description} onChange={event => setForm({ ...form, description: event.target.value })} /><SelectField label="Plantilla de email" value={form.templateId} onChange={event => setForm({ ...form, templateId: event.target.value })} required><option value="">Seleccionar...</option>{templates.data?.filter(template => template.active).map(template => <option key={template.id} value={template.id}>{template.name}</option>)}</SelectField><SelectField label="Página de aterrizaje" value={form.landingPageId} onChange={event => setForm({ ...form, landingPageId: event.target.value })} required><option value="">Seleccionar...</option>{landings.data?.filter(landing => landing.active).map(landing => <option key={landing.id} value={landing.id}>{landing.name}</option>)}</SelectField></div>{save.error ? <p className="mt-3 text-sm text-red-700">{errorText(save.error)}</p> : null}<Button type="submit" className="mt-5" disabled={save.isPending}>Crear borrador</Button></form> : null}{campaigns.isLoading ? <Skeleton cards={3} /> : campaigns.error ? <ErrorState error={campaigns.error} retry={() => campaigns.refetch()} /> : <section className="grid gap-4">{campaigns.data?.content.map(campaign => <CampaignCard key={campaign.id} campaign={campaign} deleting={remove.isPending} onDelete={() => remove.mutate(campaign.id)} />)}{!campaigns.data?.content.length ? <Empty text="Crea una campaña y asocia sus destinatarios." /> : null}</section>}</>
}
