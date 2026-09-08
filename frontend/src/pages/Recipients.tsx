import { useState } from 'react'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { api } from '../api'
import type { Page, Recipient } from '../api'
import { Button, DeleteButton, Editor, Field, PageTitle } from '../components/ui'
import { DataTable } from '../components/DataTable'
import { ErrorState, Skeleton } from '../components/States'

const emptyForm = { name: '', email: '', active: true }

export default function Recipients() {
  const client = useQueryClient(); const [editing, setEditing] = useState<Recipient | null>(null); const [creating, setCreating] = useState(false); const [form, setForm] = useState(emptyForm)
  const query = useQuery<Page<Recipient>>({ queryKey: ['recipients-table'], queryFn: () => api.get('/recipients', { params: { size: 1000 } }).then(response => response.data) })
  const save = useMutation({ mutationFn: () => editing ? api.put(`/recipients/${editing.id}`, form) : api.post('/recipients', form), onSuccess: () => { client.invalidateQueries({ queryKey: ['recipients'] }); client.invalidateQueries({ queryKey: ['recipients-table'] }); close() } })
  const remove = useMutation({ mutationFn: (id: number) => api.delete(`/recipients/${id}`), onSuccess: () => { client.invalidateQueries({ queryKey: ['recipients'] }); client.invalidateQueries({ queryKey: ['recipients-table'] }) } })
  const open = (recipient?: Recipient) => { setEditing(recipient || null); setCreating(!recipient); setForm(recipient ? { name: recipient.name, email: recipient.email, active: recipient.active } : emptyForm) }
  const close = () => { setEditing(null); setCreating(false); setForm(emptyForm) }
  if (query.isLoading) return <Skeleton cards={1} />
  if (query.error || !query.data) return <ErrorState error={query.error} retry={() => query.refetch()} />
  const rows = query.data.content.filter(recipient => recipient.active)
  return <><PageTitle eyebrow="Audiencia" title="Destinatarios" action={<Button onClick={() => open()}>Añadir destinatario</Button>} /><div className="grid gap-6 xl:grid-cols-[1fr_320px]"><DataTable rows={rows} searchKeys={[row => row.name, row => row.email]} emptyText="No hay destinatarios activos." columns={[{ key: 'name', label: 'Nombre', value: row => row.name, render: row => <b>{row.name}</b> }, { key: 'email', label: 'Email', value: row => row.email, render: row => <span className="text-slate-600">{row.email}</span> }, { key: 'actions', label: '', render: row => <div className="flex justify-end gap-3"><button type="button" className="font-semibold text-[#d95d39]" onClick={() => open(row)}>Editar</button><DeleteButton label={row.name} disabled={remove.isPending} onDelete={() => remove.mutate(row.id)} /></div>, className: 'text-right' }]} /><aside>{editing || creating ? <Editor title={editing ? 'Editar destinatario' : 'Nuevo destinatario'} onClose={close} onSubmit={event => { event.preventDefault(); save.mutate() }} error={save.error}><Field label="Nombre" value={form.name} onChange={event => setForm({ ...form, name: event.target.value })} required /><Field label="Email" type="email" value={form.email} onChange={event => setForm({ ...form, email: event.target.value })} required /><label className="flex items-center gap-2 text-sm"><input type="checkbox" checked={form.active} onChange={event => setForm({ ...form, active: event.target.checked })} /> Activo</label><Button type="submit" disabled={save.isPending}>Guardar</Button></Editor> : <div className="rounded-2xl bg-[#102a43] p-6 text-slate-200"><p className="text-xs font-bold uppercase tracking-[.15em] text-[#f2a27e]">Audiencia activa</p><p className="mt-4 font-serif text-3xl text-white">{rows.length}</p><p className="mt-3 text-sm leading-6">Busca, ordena y pagina desde una tabla consistente.</p></div>}</aside></div></>
}
