import React, { useState } from 'react';
import { Head, usePage, router } from '@inertiajs/react';
import AdminLayout from '@/layouts/AdminLayout';
import { Button } from '@/components/ui/Button';
import { Badge } from '@/components/ui/Badge';
import { Input } from '@/components/ui/Input';
import {
    AdjustStockModal,
    type AdjustStockInventory,
} from '@/components/admin/AdjustStockModal';
import type { AdminPageProps } from '@/types/admin';

interface InventoryRow extends AdjustStockInventory {
    status: 'normal' | 'low' | 'out';
    updated_at: string | null;
}

interface Paginator {
    data: InventoryRow[];
    current_page: number;
    last_page: number;
    total: number;
    per_page: number;
}

interface WarehouseOption {
    id: number;
    name: string;
}

interface Stats {
    total_variants: number;
    low_stock: number;
    out_of_stock: number;
}

interface InventoryIndexProps extends AdminPageProps {
    inventories: Paginator;
    warehouses: WarehouseOption[];
    stats: Stats;
    filters: {
        search: string;
        warehouse: number | null;
        lowStock: boolean;
    };
}

const statusMeta: Record<
    InventoryRow['status'],
    { label: string; variant: 'success' | 'warning' | 'danger' }
> = {
    normal: { label: 'Normal', variant: 'success' },
    low: { label: 'Menipis', variant: 'warning' },
    out: { label: 'Habis', variant: 'danger' },
};

export default function InventoryIndex() {
    const { inventories, warehouses, stats, filters } = usePage<InventoryIndexProps>().props;
    const rows = inventories?.data ?? [];

    const [search, setSearch] = useState(filters?.search ?? '');
    const [selectedWarehouse, setSelectedWarehouse] = useState<number | ''>(
        filters?.warehouse ?? ''
    );
    const [lowStock, setLowStock] = useState(!!filters?.lowStock);
    const [pendingAdjust, setPendingAdjust] = useState<InventoryRow | null>(null);

    const applyFilters = (overrides?: { search?: string; warehouse?: number | ''; lowStock?: boolean }) => {
        const next = {
            search: overrides?.search ?? search,
            warehouse: overrides?.warehouse ?? selectedWarehouse,
            lowStock: overrides?.lowStock ?? lowStock,
        };
        const params: Record<string, string> = {};
        if (next.search.trim()) params.search = next.search.trim();
        if (next.warehouse) params.warehouse = String(next.warehouse);
        if (next.lowStock) params.lowStock = '1';
        router.get('/admin/inventory', params, { preserveState: true, preserveScroll: true });
    };

    const buildPageUrl = (page: number) => {
        const params = new URLSearchParams();
        if (filters?.search?.trim()) params.set('search', filters.search.trim());
        if (filters?.warehouse) params.set('warehouse', String(filters.warehouse));
        if (filters?.lowStock) params.set('lowStock', '1');
        params.set('page', String(page));
        const qs = params.toString();
        return `/admin/inventory${qs ? `?${qs}` : ''}`;
    };

    return (
        <AdminLayout title="Kelola Inventory">
            <Head title="Kelola Inventory" />

            <div className="p-4 sm:p-6 md:p-8 flex flex-col gap-6">
                {/* Header */}
                <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                    <div>
                        <h2 className="text-xl sm:text-2xl font-display font-bold text-vgs-silver-bright">
                            Kelola Inventory
                        </h2>
                        <p className="text-sm text-vgs-silver-mid mt-1">
                            {inventories?.total ?? 0} product terkelola stoknya.
                        </p>
                    </div>
                </div>

                {/* Kartu ringkasan */}
                <div className="grid grid-cols-1 sm:grid-cols-3 gap-5">
                    <div className="p-5 rounded-2xl bg-vgs-black-surface border border-vgs-gray-border">
                        <p className="text-xs font-mono uppercase tracking-wider text-vgs-silver-muted">
                            Total Product
                        </p>
                        <p className="mt-2 text-2xl font-display font-bold text-vgs-silver-bright">
                            {stats?.total_variants ?? 0}
                        </p>
                        <p className="mt-1 text-xs text-vgs-silver-muted">Terkelola stoknya</p>
                    </div>
                    <div className="p-5 rounded-2xl bg-vgs-black-surface border border-vgs-gray-border">
                        <p className="text-xs font-mono uppercase tracking-wider text-vgs-silver-muted">
                            Stok Menipis
                        </p>
                        <p className="mt-2 text-2xl font-display font-bold text-vgs-warning">
                            {stats?.low_stock ?? 0}
                        </p>
                        <p className="mt-1 text-xs text-vgs-silver-muted">Stock profuct mulai berkurang</p>
                    </div>
                    <div className="p-5 rounded-2xl bg-vgs-black-surface border border-vgs-gray-border">
                        <p className="text-xs font-mono uppercase tracking-wider text-vgs-silver-muted">
                            Stok Habis
                        </p>
                        <p className="mt-2 text-2xl font-display font-bold text-vgs-danger">
                            {stats?.out_of_stock ?? 0}
                        </p>
                        <p className="mt-1 text-xs text-vgs-silver-muted">Perlu restock segera</p>
                    </div>
                </div>

                {/* Filter / pencarian */}
                <div className="rounded-2xl bg-vgs-black-surface border border-vgs-gray-border p-4 flex flex-col lg:flex-row gap-3 items-start lg:items-end">
                    <div className="flex-1 w-full">
                        <Input
                            label="Cari Produk / SKU"
                            placeholder="Ketik nama produk atau SKU…"
                            value={search}
                            onChange={(e) => setSearch(e.target.value)}
                            onKeyDown={(e) => {
                                if (e.key === 'Enter') applyFilters();
                            }}
                        />
                    </div>
                    <div className="w-full lg:w-56">
                        <label className="text-xs font-semibold uppercase tracking-wider text-vgs-silver-mid block mb-1.5">
                            Gudang
                        </label>
                        <select
                            value={selectedWarehouse}
                            onChange={(e) => {
                                const next = e.target.value === '' ? '' : Number(e.target.value);
                                setSelectedWarehouse(next);
                                applyFilters({ warehouse: next });
                            }}
                            className="w-full min-h-[44px] bg-vgs-black-surface text-vgs-silver-bright text-sm rounded-xl px-4 py-3 border border-vgs-gray-border focus:outline-none focus:border-vgs-blue-electric focus:ring-2 focus:ring-vgs-blue-electric/30"
                        >
                            <option value="">Semua Gudang</option>
                            {(warehouses ?? []).map((w) => (
                                <option key={w.id} value={w.id}>
                                    {w.name}
                                </option>
                            ))}
                        </select>
                    </div>
                    <button
                        type="button"
                        onClick={() => {
                            const next = !lowStock;
                            setLowStock(next);
                            applyFilters({ lowStock: next });
                        }}
                        aria-pressed={lowStock}
                        className={`inline-flex items-center gap-2.5 min-h-[44px] px-4 rounded-xl text-sm font-semibold border transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-vgs-blue-electric cursor-pointer ${
                            lowStock
                                ? 'bg-vgs-warning/15 text-vgs-warning border-vgs-warning/30'
                                : 'bg-vgs-black-surface text-vgs-silver-mid border-vgs-gray-border hover:border-vgs-blue-electric hover:text-vgs-silver-bright'
                        }`}
                    >
                        <span
                            className={`w-4 h-4 rounded flex items-center justify-center border ${
                                lowStock
                                    ? 'bg-vgs-warning border-vgs-warning text-vgs-black-void'
                                    : 'border-vgs-gray-border'
                            }`}
                        >
                            {lowStock && (
                                <svg className="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="3" d="M5 13l4 4L19 7" />
                                </svg>
                            )}
                        </span>
                        Hanya stok menipis
                    </button>
                </div>

                {/* Tabel */}
                <div className="rounded-2xl bg-vgs-black-surface border border-vgs-gray-border overflow-hidden">
                    <div className="overflow-x-auto">
                        <table className="w-full text-sm">
                            <thead>
                                <tr className="text-left border-b border-vgs-gray-border bg-vgs-black-elevated/40">
                                    <th className="px-6 py-3 text-[10px] font-mono uppercase tracking-widest text-vgs-silver-muted">
                                        Produk / SKU
                                    </th>
                                    <th className="px-6 py-3 text-[10px] font-mono uppercase tracking-widest text-vgs-silver-muted">
                                        Gudang
                                    </th>
                                    <th className="px-6 py-3 text-[10px] font-mono uppercase tracking-widest text-vgs-silver-muted">
                                        Stok Saat Ini
                                    </th>
                                    <th className="px-6 py-3 text-[10px] font-mono uppercase tracking-widest text-vgs-silver-muted">
                                        Direservasi
                                    </th>
                                    <th className="px-6 py-3 text-[10px] font-mono uppercase tracking-widest text-vgs-silver-muted">
                                        Status
                                    </th>
                                    <th className="px-6 py-3 text-right text-[10px] font-mono uppercase tracking-widest text-vgs-silver-muted">
                                        Aksi
                                    </th>
                                </tr>
                            </thead>
                            <tbody className="divide-y divide-vgs-gray-border/60">
                                {rows.length === 0 && (
                                    <tr>
                                        <td colSpan={6} className="px-6 py-12 text-center">
                                            <p className="text-vgs-silver-mid">
                                                Belum ada data inventory.
                                            </p>
                                            <p className="text-xs text-vgs-silver-muted mt-1">
                                                Coba ubah filter atau pencarian.
                                            </p>
                                        </td>
                                    </tr>
                                )}
                                {rows.map((row) => {
                                    const meta = statusMeta[row.status];
                                    const available = row.quantity_on_hand - row.quantity_reserved;
                                    return (
                                        <tr key={row.id} className="hover:bg-vgs-black-elevated/40 transition-colors">
                                            <td className="px-6 py-4">
                                                <p className="font-semibold text-vgs-silver-bright">
                                                    {row.product_name}
                                                </p>
                                                <p className="text-xs font-mono text-vgs-silver-muted">
                                                    {row.sku}
                                                </p>
                                            </td>
                                            <td className="px-6 py-4 text-vgs-silver-mid">
                                                {row.warehouse_name}
                                            </td>
                                            <td className="px-6 py-4 whitespace-nowrap">
                                                <div className="flex items-baseline gap-2">
                                                    <span className="text-lg font-display font-bold text-vgs-silver-bright">
                                                        {row.quantity_on_hand}
                                                    </span>
                                                    {row.quantity_reserved > 0 && (
                                                        <span className="text-xs text-vgs-silver-muted font-mono">
                                                            {available} tersedia
                                                        </span>
                                                    )}
                                                </div>
                                            </td>
                                            <td className="px-6 py-4 text-vgs-silver-mid whitespace-nowrap">
                                                {row.quantity_reserved > 0
                                                    ? row.quantity_reserved
                                                    : '—'}
                                            </td>
                                            <td className="px-6 py-4">
                                                <Badge variant={meta.variant} dot>
                                                    {meta.label}
                                                </Badge>
                                            </td>
                                            <td className="px-6 py-4">
                                                <div className="flex items-center justify-end">
                                                    <button
                                                        type="button"
                                                        onClick={() => setPendingAdjust(row)}
                                                        className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-semibold text-vgs-blue-electric border border-vgs-blue-electric/30 hover:bg-vgs-blue-electric/10 transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-vgs-blue-electric"
                                                    >
                                                        Sesuaikan Stok
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    );
                                })}
                            </tbody>
                        </table>
                    </div>

                    {inventories && inventories.last_page > 1 && (
                        <div className="px-6 py-4 border-t border-vgs-gray-border flex items-center justify-between">
                            <span className="text-xs text-vgs-silver-muted">
                                Halaman {inventories.current_page} dari {inventories.last_page}
                            </span>
                            <div className="flex items-center gap-2">
                                <Button
                                    variant="secondary"
                                    size="sm"
                                    href={
                                        inventories.current_page > 1
                                            ? buildPageUrl(inventories.current_page - 1)
                                            : undefined
                                    }
                                    disabled={inventories.current_page <= 1}
                                >
                                    Sebelumnya
                                </Button>
                                <Button
                                    variant="secondary"
                                    size="sm"
                                    href={
                                        inventories.current_page < inventories.last_page
                                            ? buildPageUrl(inventories.current_page + 1)
                                            : undefined
                                    }
                                    disabled={inventories.current_page >= inventories.last_page}
                                >
                                    Berikutnya
                                </Button>
                            </div>
                        </div>
                    )}
                </div>
            </div>

            {pendingAdjust && (
                <AdjustStockModal
                    inventory={pendingAdjust}
                    onClose={() => setPendingAdjust(null)}
                />
            )}
        </AdminLayout>
    );
}
