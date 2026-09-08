import { errorText } from './ui'

export function Skeleton({ cards = 4 }: { cards?: number }) { return <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">{Array.from({ length: cards }, (_, index) => <div key={index} className="h-32 animate-pulse rounded-2xl bg-slate-200" />)}</div> }
export function ErrorState({ error, retry }: { error: unknown; retry: () => void }) { return <div className="rounded-2xl border border-red-100 bg-red-50 p-6 text-red-800"><p className="font-semibold">No se pudo cargar esta vista.</p><p className="mt-1 text-sm">{errorText(error)}</p><button type="button" onClick={retry} className="mt-4 rounded-lg border border-red-200 bg-white px-3 py-2 text-sm font-semibold">Reintentar</button></div> }
