import { FormEvent, useState } from 'react'
import { useNavigate } from 'react-router'
import { api } from '../api'
import { Button, errorText, Field } from '../components/ui'

export default function Login({ onLogin }: { onLogin: () => void }) {
  const navigate = useNavigate()
  const [form, setForm] = useState({ username: '', password: '' })
  const [message, setMessage] = useState('')
  const submit = async (event: FormEvent) => { event.preventDefault(); setMessage(''); try { const response = await api.post('/auth/login', form); localStorage.setItem('paware.jwt', response.data.token); localStorage.setItem('paware.user', JSON.stringify(response.data)); onLogin(); navigate('/') } catch (error) { setMessage(errorText(error)) } }
  return <main className="grid min-h-screen place-items-center bg-[#102a43] px-6 py-12"><section className="grid w-full max-w-5xl overflow-hidden rounded-3xl bg-[#f7f3ed] shadow-2xl md:grid-cols-[1.1fr_.9fr]"><div className="hidden bg-[#d95d39] p-12 text-[#fff8ed] md:block"><p className="text-sm font-bold uppercase tracking-[.28em]">PAWARE / SALA DE CONTROL</p><h1 className="mt-24 max-w-sm font-serif text-6xl leading-[.95]">Que ese clic de riesgo sea el último.</h1><p className="mt-8 max-w-sm text-lg text-orange-50">Un espacio enfocado en simulaciones éticas, aprendizaje medible y mejores hábitos.</p></div><form onSubmit={submit} className="p-8 md:p-12"><p className="text-sm font-bold uppercase tracking-[.24em] text-[#d95d39]">Acceso administrativo</p><h1 className="mt-3 font-serif text-4xl text-[#102a43]">Qué bueno verte.</h1><p className="mt-3 text-slate-500">Inicia sesión para gestionar tu programa de concienciación.</p><div className="mt-10 grid gap-4"><Field label="Usuario" value={form.username} onChange={event => setForm({ ...form, username: event.target.value })} required autoComplete="username" /><Field label="Contraseña" type="password" value={form.password} onChange={event => setForm({ ...form, password: event.target.value })} required autoComplete="current-password" /></div>{message && <p className="mt-4 rounded-lg bg-red-50 p-3 text-sm text-red-700">{message}</p>}<Button type="submit" className="mt-8 w-full">Entrar al panel</Button><p className="mt-6 text-center text-xs text-slate-400">Entorno interno. Usa las credenciales del programa.</p></form></section></main>
}
