import { FormEvent, InputHTMLAttributes, ReactNode, SelectHTMLAttributes } from 'react'

export function errorText(error: unknown) {
  if (error && typeof error === 'object' && 'response' in error) {
    const response = (error as { response?: { data?: { message?: string } } }).response
    return response?.data?.message || 'La solicitud no pudo completarse.'
  }
  return 'La solicitud no pudo completarse.'
}

const translations: Record<string, string> = {
  Overview: 'Resumen', Analytics: 'Analítica', Operations: 'Operación', Audience: 'Audiencia', 'Content library': 'Biblioteca de contenido', Administration: 'Administración', 'Campaign detail': 'Detalle de campaña',
  'A calmer view of risk': 'Una vista serena del riesgo', 'Risk report': 'Informe de riesgo', Campaigns: 'Campañas', Recipients: 'Destinatarios', 'Email templates': 'Plantillas de email', 'Landing pages': 'Páginas de aterrizaje', 'Admin users': 'Usuarios admin',
  'New template': 'Nueva plantilla', 'Edit email template': 'Editar plantilla de email', 'New email template': 'Nueva plantilla de email', 'New landing page': 'Nueva página de aterrizaje', 'Edit landing page': 'Editar página de aterrizaje', 'Add recipient': 'Añadir destinatario', 'Edit recipient': 'Editar destinatario', 'New recipient': 'Nuevo destinatario', 'New admin user': 'Nuevo usuario admin',
  Close: 'Cerrar', 'New campaign': 'Nueva campaña', 'Create draft': 'Crear borrador', Back: 'Volver', 'Export CSV': 'Exportar CSV', Launch: 'Lanzar', 'Open rate': 'Tasa de apertura', 'Click rate': 'Tasa de clics', 'Submit rate': 'Tasa de envío', 'Training rate': 'Tasa de formación', 'Add recipients': 'Añadir destinatarios', 'Associate selected': 'Asociar seleccionados', 'Recipient funnel': 'Embudo de destinatarios', Copy: 'Copiar', 'Create user': 'Crear usuario', Username: 'Usuario', 'Temporary password': 'Contraseña temporal', Role: 'Rol', 'Email template': 'Plantilla de email', 'Landing page': 'Página de aterrizaje', Name: 'Nombre', Status: 'Estado', ACTIVE: 'ACTIVO', INACTIVE: 'INACTIVO', DISABLED: 'DESACTIVADO',
  'Description': 'Descripción', Descripcion: 'Descripción', Categoria: 'Categoría', Dificultad: 'Dificultad', Contrasena: 'Contraseña', Campana: 'Campaña',
}

export function translate(value: string) { return translations[value] || value }

export function Button({ children, variant = 'primary', className, ...props }: React.ButtonHTMLAttributes<HTMLButtonElement> & { children: ReactNode; variant?: 'primary' | 'muted' | 'danger' }) {
  const styles = variant === 'primary' ? 'bg-[#d95d39] text-white hover:bg-[#bf4b2a]' : variant === 'danger' ? 'border border-red-200 text-red-700 hover:bg-red-50' : 'border border-slate-200 bg-white text-slate-700 hover:bg-slate-50'
  return <button className={`rounded-lg px-4 py-2 text-sm font-semibold transition ${styles} ${className || ''}`} {...props}>{typeof children === 'string' ? translate(children) : children}</button>
}

export function Field({ label, ...props }: InputHTMLAttributes<HTMLInputElement> & { label: string }) { return <label className="grid gap-1 text-sm font-semibold text-slate-700"><span>{translate(label)}</span><input className="rounded-lg border border-slate-200 bg-white px-3 py-2 font-normal outline-none ring-[#d95d39] focus:ring-2" {...props} /></label> }
export function SelectField({ label, children, ...props }: SelectHTMLAttributes<HTMLSelectElement> & { label: string; children: ReactNode }) { return <label className="grid gap-1 text-sm font-semibold text-slate-700"><span>{translate(label)}</span><select className="rounded-lg border border-slate-200 bg-white px-3 py-2 font-normal outline-none ring-[#d95d39] focus:ring-2" {...props}>{children}</select></label> }
export function PageTitle({ eyebrow, title, action }: { eyebrow: string; title: string; action?: ReactNode }) { return <div className="mb-8 flex flex-wrap items-end justify-between gap-4"><div><p className="text-xs font-bold uppercase tracking-[.22em] text-[#d95d39]">{translate(eyebrow)}</p><h1 className="mt-2 font-serif text-4xl text-[#102a43]">{translate(title)}</h1></div>{action}</div> }
export function StatCard({ label, value, note }: { label: string; value: string | number; note: string }) { return <article className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm"><p className="text-xs font-bold uppercase tracking-[.14em] text-slate-400">{translate(label)}</p><p className="mt-3 font-serif text-4xl text-[#102a43]">{value}</p><p className="mt-2 text-sm text-slate-500">{translate(note)}</p></article> }
export function Empty({ text }: { text: string }) { return <div className="rounded-2xl border border-dashed border-slate-300 bg-white p-10 text-center text-slate-500">{translate(text)}</div> }
export function Editor({ title, children, onClose, onSubmit, error }: { title: string; children: ReactNode; onClose: () => void; onSubmit: (event: FormEvent) => void; error?: unknown }) { return <form onSubmit={onSubmit} className="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm"><div className="flex items-center justify-between"><h2 className="font-serif text-2xl">{translate(title)}</h2><button type="button" onClick={onClose} aria-label="Cerrar editor" className="text-slate-400">Cerrar</button></div><div className="mt-5 grid gap-4">{children}</div>{error ? <p className="mt-4 text-sm text-red-700">{errorText(error)}</p> : null}</form> }
