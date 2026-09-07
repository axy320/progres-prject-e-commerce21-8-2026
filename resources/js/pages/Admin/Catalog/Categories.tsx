import React, { useState } from 'react';
import { Head, usePage, router } from '@inertiajs/react';
import AdminLayout from '@/layouts/AdminLayout';
import { Button } from '@/components/ui/Button';
import { Badge } from '@/components/ui/Badge';
import { Modal } from '@/components/ui/Modal';
import CategoryFormModal, {
    type CategoryRow,
    type CategoryParentOption,
} from '@/components/admin/CategoryFormModal';
import type { AdminPageProps } from '@/types/admin';

interface CategoriesProps extends AdminPageProps {
    categories: CategoryRow[];
    parents: CategoryParentOption[];
}

const statusMeta: Record<CategoryRow['status'], { label: string; variant: 'success' | 'neutral' | 'warning' }> = {
    published: { label: 'Published', variant: 'success' },
    draft: { label: 'Draft', variant: 'neutral' },
    archived: { label: 'Archived', variant: 'warning' },
};

export default function Categories() {
    const { categories, parents, flash } = usePage<CategoriesProps>().props;
    const rows = categories ?? [];

    const [formOpen, setFormOpen] = useState(false);
    const [editing, setEditing] = useState<CategoryRow | null>(null);
    const [pendingDelete, setPendingDelete] = useState<CategoryRow | null>(null);

    const openCreate = () => {
        setEditing(null);
        setFormOpen(true);
    };

    const openEdit = (category: CategoryRow) => {
        setEditing(category);
        setFormOpen(true);
    };

    const handleConfirmDelete = () => {
        if (!pendingDelete) return;
        router.delete(`/admin/categories/${pendingDelete.id}`, {
            preserveScroll: true,
            onSuccess: () => setPendingDelete(null),
        });
    };

    return (
        <AdminLayout title="Kelola Kategori">
            <Head title="Kelola Kategori" />

            <div className="p-4 sm:p-6 md:p-8 flex flex-col gap-6">
                {flash?.success && (
                    <p className="text-sm text-vgs-success border border-vgs-success/30 bg-vgs-success/10 rounded-lg px-3 py-2">
                        {flash.success}
                    </p>
                )}
                {flash?.error && (
                    <p className="text-sm text-vgs-danger border border-vgs-danger/30 bg-vgs-danger/10 rounded-lg px-3 py-2">
                        {flash.error}
                    </p>
                )}

                <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                    <div>
                        <h2 className="text-xl sm:text-2xl font-display font-bold text-vgs-silver-bright">
                            Kelola Kategori
                        </h2>
                        <p className="text-sm text-vgs-silver-mid mt-1">
                            {rows.length} kategori untuk produk di katalog.
                        </p>
                    </div>
                    <Button onClick={openCreate} variant="primary">
                        + Tambah Kategori
                    </Button>
                </div>

                <div className="rounded-2xl bg-vgs-black-surface border border-vgs-gray-border overflow-hidden">
                    <div className="overflow-x-auto">
                        <table className="w-full text-sm">
                            <thead>
                                <tr className="text-left border-b border-vgs-gray-border bg-vgs-black-elevated/40">
                                    <th className="px-6 py-3 text-[10px] font-mono uppercase tracking-widest text-vgs-silver-muted">
                                        Kategori
                                    </th>
                                    <th className="px-6 py-3 text-[10px] font-mono uppercase tracking-widest text-vgs-silver-muted">
                                        Induk
                                    </th>
                                    <th className="px-6 py-3 text-[10px] font-mono uppercase tracking-widest text-vgs-silver-muted">
                                        Produk
                                    </th>
                                    <th className="px-6 py-3 text-[10px] font-mono uppercase tracking-widest text-vgs-silver-muted">
                                        Sub-kategori
                                    </th>
                                    <th className="px-6 py-3 text-[10px] font-mono uppercase tracking-widest text-vgs-silver-muted">
                                        Status
                                    </th>
                                    <th className="px-6 py-3 text-[10px] font-mono uppercase tracking-widest text-vgs-silver-muted">
                                        Urutan
                                    </th>
                                    <th className="px-6 py-3 text-[10px] font-mono uppercase tracking-widest text-vgs-silver-muted">
                                        Dibuat
                                    </th>
                                    <th className="px-6 py-3 text-right text-[10px] font-mono uppercase tracking-widest text-vgs-silver-muted">
                                        Aksi
                                    </th>
                                </tr>
                            </thead>
                            <tbody className="divide-y divide-vgs-gray-border/60">
                                {rows.length === 0 && (
                                    <tr>
                                        <td colSpan={8} className="px-6 py-12 text-center">
                                            <p className="text-vgs-silver-mid">
                                                Belum ada kategori. Mulai dengan menambahkan kategori pertama.
                                            </p>
                                            <Button
                                                variant="primary"
                                                size="md"
                                                onClick={openCreate}
                                                className="mt-5"
                                            >
                                                + Tambah Kategori
                                            </Button>
                                        </td>
                                    </tr>
                                )}
                                {rows.map((category) => {
                                    const meta = statusMeta[category.status] ?? statusMeta.draft;
                                    return (
                                        <tr key={category.id} className="hover:bg-vgs-black-elevated/40 transition-colors">
                                            <td className="px-6 py-4">
                                                <p className="font-semibold text-vgs-silver-bright">
                                                    {category.name}
                                                </p>
                                                <p className="text-xs font-mono text-vgs-silver-muted">
                                                    /{category.slug}
                                                </p>
                                            </td>
                                            <td className="px-6 py-4 text-vgs-silver-mid">
                                                {category.parent_name ?? '—'}
                                            </td>
                                            <td className="px-6 py-4 text-vgs-silver-bright font-semibold">
                                                {category.products_count}
                                            </td>
                                            <td className="px-6 py-4 text-vgs-silver-mid">
                                                {category.children_count}
                                            </td>
                                            <td className="px-6 py-4">
                                                <Badge variant={meta.variant} dot>
                                                    {meta.label}
                                                </Badge>
                                            </td>
                                            <td className="px-6 py-4 text-vgs-silver-mid whitespace-nowrap">
                                                {category.sort_order}
                                            </td>
                                            <td className="px-6 py-4 text-vgs-silver-muted whitespace-nowrap">
                                                {category.created_at ?? '—'}
                                            </td>
                                            <td className="px-6 py-4">
                                                <div className="flex items-center justify-end gap-2">
                                                    <button
                                                        type="button"
                                                        onClick={() => openEdit(category)}
                                                        className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-semibold text-vgs-blue-electric border border-vgs-blue-electric/30 hover:bg-vgs-blue-electric/10 transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-vgs-blue-electric cursor-pointer"
                                                    >
                                                        Edit
                                                    </button>
                                                    <button
                                                        type="button"
                                                        onClick={() => setPendingDelete(category)}
                                                        className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-semibold text-vgs-danger border border-vgs-danger/30 hover:bg-vgs-danger/10 transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-vgs-danger cursor-pointer"
                                                    >
                                                        Hapus
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    );
                                })}
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <CategoryFormModal
                open={formOpen}
                onClose={() => setFormOpen(false)}
                category={editing}
                parents={parents ?? []}
            />

            <Modal
                isOpen={pendingDelete !== null}
                onClose={() => setPendingDelete(null)}
                title="Hapus kategori"
                size="sm"
            >
                <p className="text-sm text-vgs-silver-mid">
                    Yakin ingin menghapus kategori{' '}
                    <span className="font-semibold text-vgs-silver-bright">{pendingDelete?.name}</span>?
                    Tindakan ini tidak dapat dibatalkan.
                </p>
                {pendingDelete && pendingDelete.children_count > 0 && (
                    <p className="text-xs text-vgs-warning mt-2">
                        Kategori ini memiliki {pendingDelete.children_count} sub-kategori yang akan menjadi kategori utama.
                    </p>
                )}
                <div className="mt-6 flex items-center justify-end gap-3">
                    <Button variant="secondary" onClick={() => setPendingDelete(null)}>
                        Batal
                    </Button>
                    <Button variant="danger" onClick={handleConfirmDelete}>
                        Hapus
                    </Button>
                </div>
            </Modal>
        </AdminLayout>
    );
}