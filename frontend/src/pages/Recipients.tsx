import { ChangeEvent, useState } from 'react'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { api } from '../api'
import type { Page, Recipient, RecipientBatchResult } from '../api'
import { Button, DeleteButton, Editor, errorText, Field, PageTitle } from '../components/ui'
import { DataTable } from '../components/DataTable'
import { ErrorState, Skeleton } from '../components/States'

const emptyForm = { name: '', email: '', active: true }
const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
type CsvRow = { row: number; name: string; email: string; reason?: string }

function normalize(value: string) { return value.normalize('NFD').replace(/[\u0300-\u036f]/g, '').trim().toLowerCase() }

function parseCsv(text: string): CsvRow[] {
  const firstLine = text.split(/\r?\n/, 1)[0] || ''
  const delimiter = firstLine.split(';').length > firstLine.split(',').length ? ';' : ','
  const values: string[][] = []; let row: string[] = []; let value = ''; let quoted = false
  for (let index = 0; index < text.length; index++) {
    const character = text[index]
    if (character === '"') { if (quoted && text[index + 1] === '"') { value += '"'; index++ } else quoted = !quoted; continue }
    if (character === delimiter && !quoted) { row.push(value.trim()); value = ''; continue }
    if ((character === '\n' || character === '\r') && !quoted) { if (character === '\r' && text[index + 1] === '\n') index++; row.push(value.trim()); if (row.some(cell => cell)) values.push(row); row = []; value = ''; continue }
    value += character
  }
  row.push(value.trim()); if (row.some(cell => cell)) values.push(row)
  if (!values.length) return []
  const headers = (values[0] || []).map(normalize)
  const nameColumn = headers.findIndex(header => ['nombre', 'name'].includes(header))
  const emailColumn = headers.findIndex(header => ['email', 'correo'].includes(header))
  const hasHeader = nameColumn >= 0 && emailColumn >= 0
  const seen = new Set<string>()
  return values.slice(hasHeader ? 1 : 0).map((cells, index) => {
    const name = cells[hasHeader ? nameColumn : 0] || ''
    const email = (cells[hasHeader ? emailColumn : 1] || '').trim().toLowerCase()
    const rowNumber = index + (hasHeader ? 2 : 1)
    const reason = !name.trim() ? 'Nombre requerido' : !emailPattern.test(email) ? 'Email inválido' : seen.has(email) ? 'Email repetido en archivo' : undefined
    if (!reason) seen.add(email)
    return { row: rowNumber, name: name.trim(), email, reason }
  })
}

function ImportDialog({ onClose, onImported }: { onClose: () => void; onImported: () => void }) {
  const [rows, setRows] = useState<CsvRow[]>([])
  const [fileName, setFileName] = useState('')
  const [result, setResult] = useState<RecipientBatchResult | null>(null)
  const importBatch = useMutation({ mutationFn: () => api.post<RecipientBatchResult>('/recipients/batch', { items: rows.map(row => ({ row: row.row, name: row.name, email: row.email })) }).then(response => response.data), onSuccess: response => { setResult(response); onImported() } })
  const readFile = async (event: ChangeEvent<HTMLInputElement>) => { const file = event.target.files?.[0]; if (!file) return; setFileName(file.name); setRows(parseCsv(await file.text())); setResult(null); event.target.value = '' }
  const validRows = rows.filter(row => !row.reason)
  const failures = result?.failedItems || rows.filter(row => row.reason).map(row => ({ ...row, reason: row.reason || '' }))
  return <div className="fixed inset-0 z-50 grid place-items-center bg-[#102a43]/45 p-4" role="dialog" aria-modal="true" aria-labelledby="import-title"><section className="max-h-[90vh] w-full max-w-3xl overflow-y-auto rounded-2xl bg-white p-6 shadow-xl"><div className="flex items-start justify-between gap-4"><div><p className="text-xs font-bold uppercase tracking-[.15em] text-[#d95d39]">Audiencia</p><h2 id="import-title" className="mt-1 font-serif text-2xl text-[#102a43]">Importar destinatarios CSV</h2></div><Button variant="muted" onClick={onClose}>Cerrar</Button></div><p className="mt-3 text-sm text-slate-600">Acepta columnas <b>nombre,email</b>, <b>name,email</b> o <b>nombre,correo</b>. Sin cabecera: primera y segunda columna.</p><label className="mt-5 flex cursor-pointer items-center justify-center rounded-xl border-2 border-dashed border-slate-300 bg-slate-50 px-5 py-8 text-center transition hover:border-[#d95d39] hover:bg-orange-50"><span><b className="block text-[#102a43]">Seleccionar archivo CSV</b><span className="mt-1 block text-sm text-slate-500">Excel: Guardar como CSV</span></span><input type="file" accept=".csv,text/csv" className="sr-only" onChange={readFile} /></label>{fileName ? <p className="mt-3 text-sm text-slate-500">Archivo: {fileName} · {rows.length} filas detectadas</p> : null}{rows.length ? <><div className="mt-5 overflow-x-auto rounded-xl border border-slate-200"><table className="w-full text-left text-sm"><thead className="bg-slate-50 text-xs uppercase tracking-wide text-slate-500"><tr><th className="p-3">Fila</th><th className="p-3">Nombre</th><th className="p-3">Email</th><th className="p-3">Validación</th></tr></thead><tbody>{rows.slice(0, 5).map(row => <tr key={row.row} className="border-t border-slate-100"><td className="p-3">{row.row}</td><td className="p-3">{row.name || '—'}</td><td className="p-3">{row.email || '—'}</td><td className={`p-3 font-semibold ${row.reason ? 'text-red-700' : 'text-emerald-700'}`}>{row.reason || 'Lista'}</td></tr>)}</tbody></table></div>{rows.length > 5 ? <p className="mt-2 text-xs text-slate-500">Vista previa: primeras 5 de {rows.length} filas.</p> : null}</> : null}{result ? <div className="mt-5 rounded-xl bg-emerald-50 p-4 text-sm text-emerald-900"><b>{result.successCount} importados</b> · {result.createdCount} nuevos · {result.updatedCount} actualizados</div> : null}{importBatch.error ? <p className="mt-4 text-sm text-red-700">{errorText(importBatch.error)}</p> : null}{failures.length ? <div className="mt-4 rounded-xl bg-red-50 p-4 text-sm text-red-900"><b>{failures.length} filas omitidas</b><ul className="mt-2 grid gap-1">{failures.slice(0, 10).map(failure => <li key={`${failure.row}-${failure.email}`}>Fila {failure.row}: {failure.reason}</li>)}</ul>{failures.length > 10 ? <p className="mt-2">Mostrando 10 errores.</p> : null}</div> : null}<div className="mt-6 flex flex-wrap justify-end gap-3"><Button variant="muted" onClick={onClose}>Cerrar</Button><Button onClick={() => importBatch.mutate()} disabled={!validRows.length || importBatch.isPending}>{importBatch.isPending ? 'Importando...' : `Importar ${validRows.length} destinatarios`}</Button></div></section></div>
}

export default function Recipients() {
  const client = useQueryClient(); const [editing, setEditing] = useState<Recipient | null>(null); const [creating, setCreating] = useState(false); const [importing, setImporting] = useState(false); const [form, setForm] = useState(emptyForm)
  const query = useQuery<Page<Recipient>>({ queryKey: ['recipients-table'], queryFn: () => api.get('/recipients', { params: { size: 1000 } }).then(response => response.data) })
  const invalidate = () => { client.invalidateQueries({ queryKey: ['recipients'] }); client.invalidateQueries({ queryKey: ['recipients-table'] }) }
  const save = useMutation({ mutationFn: () => editing ? api.put(`/recipients/${editing.id}`, form) : api.post('/recipients', form), onSuccess: () => { invalidate(); close() } })
  const remove = useMutation({ mutationFn: (id: number) => api.delete(`/recipients/${id}`), onSuccess: invalidate })
  const open = (recipient?: Recipient) => { setEditing(recipient || null); setCreating(!recipient); setForm(recipient ? { name: recipient.name, email: recipient.email, active: recipient.active } : emptyForm) }
  const close = () => { setEditing(null); setCreating(false); setForm(emptyForm) }
  if (query.isLoading) return <Skeleton cards={1} />
  if (query.error || !query.data) return <ErrorState error={query.error} retry={() => query.refetch()} />
  const rows = query.data.content.filter(recipient => recipient.active)
  return <><PageTitle eyebrow="Audiencia" title="Destinatarios" action={<div className="flex flex-wrap gap-2"><Button variant="muted" onClick={() => setImporting(true)}>Importar CSV</Button><Button onClick={() => open()}>Añadir destinatario</Button></div>} /><div className="grid gap-6 xl:grid-cols-[1fr_320px]"><DataTable rows={rows} searchKeys={[row => row.name, row => row.email]} emptyText="No hay destinatarios activos." columns={[{ key: 'name', label: 'Nombre', value: row => row.name, render: row => <b>{row.name}</b> }, { key: 'email', label: 'Email', value: row => row.email, render: row => <span className="text-slate-600">{row.email}</span> }, { key: 'actions', label: '', render: row => <div className="flex justify-end gap-3"><button type="button" className="font-semibold text-[#d95d39]" onClick={() => open(row)}>Editar</button><DeleteButton label={row.name} disabled={remove.isPending} onDelete={() => remove.mutate(row.id)} /></div>, className: 'text-right' }]} /><aside>{editing || creating ? <Editor title={editing ? 'Editar destinatario' : 'Nuevo destinatario'} onClose={close} onSubmit={event => { event.preventDefault(); save.mutate() }} error={save.error}><Field label="Nombre" value={form.name} onChange={event => setForm({ ...form, name: event.target.value })} required /><Field label="Email" type="email" value={form.email} onChange={event => setForm({ ...form, email: event.target.value })} required /><label className="flex items-center gap-2 text-sm"><input type="checkbox" checked={form.active} onChange={event => setForm({ ...form, active: event.target.checked })} /> Activo</label><Button type="submit" disabled={save.isPending}>Guardar</Button></Editor> : <div className="rounded-2xl bg-[#102a43] p-6 text-slate-200"><p className="text-xs font-bold uppercase tracking-[.15em] text-[#f2a27e]">Audiencia activa</p><p className="mt-4 font-serif text-3xl text-white">{rows.length}</p><p className="mt-3 text-sm leading-6">Busca, ordena, importa y administra destinatarios desde un solo lugar.</p></div>}</aside></div>{importing ? <ImportDialog onClose={() => setImporting(false)} onImported={invalidate} /> : null}</>
}
