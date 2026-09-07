import React from 'react';
import { Link, router, usePage } from '@inertiajs/react';
import { useSidebar } from '@/components/admin/SidebarContext';
import type { AdminUser } from '@/components/admin/SidebarContext';

export interface NavItem {
    label: string;
    href: string;
    icon: React.ReactNode;
    active?: boolean;
}

export interface NavGroup {
    label?: string;
    items: NavItem[];
}

interface SidebarProps {
    user?: AdminUser | null;
    navGroups?: NavGroup[];
}

// Menu placeholder sesuai modul arsitektur bagian 4.2. Sebagian link masih
// placeholder sampai modulnya tersedia.
const DEFAULT_NAV_GROUPS: NavGroup[] = [
    {
        items: [
            {
                label: 'Dashboard',
                href: '/admin/dashboard',
                icon: (
                    <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M3 12l9-9 9 9M5 10v10a1 1 0 001 1h4v-6h4v6h4a1 1 0 001-1V10" />
                    </svg>
                ),
            },
        ],
    },
    {
        label: 'Katalog & Inventori',
        items: [
            {
                label: 'Catalog',
                href: '/admin/products',
                icon: (
                    <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M4 6h16M4 12h16M4 18h16" />
                    </svg>
                ),
            },
            {
                label: 'Categories',
                href: '/admin/categories',
                icon: (
                    <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-6l-2-2H5a2 2 0 00-2 2z" />
                    </svg>
                ),
            },
            {
                label: 'Inventory',
                href: '/admin/inventory',
                icon: (
                    <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4" />
                    </svg>
                ),
            },
        ],
    },
    {
        label: 'Penjualan & Operasional',
        items: [
            {
                label: 'Orders',
                href: '#',
                icon: (
                    <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z" />
                    </svg>
                ),
            },
            {
                label: 'Customers',
                href: '#',
                icon: (
                    <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
                    </svg>
                ),
            },
        ],
    },
    {
        label: 'Perluasan & Pengaturan',
        items: [
            {
                label: 'Marketing',
                href: '#',
                icon: (
                    <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M11 5.882V19.24a1.76 1.76 0 01-3.417.592l-2.147-6.15M18 13a3 3 0 100-6M5.436 13.683A4.001 4.001 0 017 6h1.832c4.1 0 7.625-1.234 9.168-3v14c-1.543-1.766-5.067-3-9.168-3H7a3.988 3.988 0 01-1.564-.317z" />
                    </svg>
                ),
            },
            {
                label: 'Reports',
                href: '#',
                icon: (
                    <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                    </svg>
                ),
            },
            {
                label: 'Configuration',
                href: '#',
                icon: (
                    <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                    </svg>
                ),
            },
        ],
    },
];

export const Sidebar: React.FC<SidebarProps> = ({ user, navGroups }) => {
    const { url } = usePage();
    const { isOpen, close } = useSidebar();

    const groups = navGroups ?? DEFAULT_NAV_GROUPS;

    const displayUser: AdminUser | null =
        user ?? (usePage<{ auth: { user?: AdminUser | null } }>().props.auth?.user ?? null);

    const isItemActive = (item: NavItem) => {
        if (item.href === '#' || item.href === '') return false;
        if (item.href === '/admin/dashboard') return url.startsWith('/admin/dashboard') || url === '/admin';
        return url.startsWith(item.href);
    };

    const initials = displayUser?.name
        ? displayUser.name.split(' ').map((n) => n[0]).join('').toUpperCase().slice(0, 2)
        : 'VG';

    const roleName = displayUser?.roles && displayUser.roles.length > 0
        ? displayUser.roles[0].name
        : 'Staf';

    const handleLogout = () => {
        close();
        router.post('/logout');
    };

    return (
        <>
            {/* Mobile backdrop */}
            {isOpen && (
                <div
                    className="fixed inset-0 z-40 bg-black/70 backdrop-blur-sm md:hidden"
                    onClick={close}
                    aria-hidden="true"
                />
            )}

            <aside
                className={`fixed inset-y-0 left-0 z-50 flex w-[260px] flex-col bg-vgs-black-surface border-r border-vgs-gray-border transition-transform duration-300 md:translate-x-0 ${
                    isOpen ? 'translate-x-0' : '-translate-x-full'
                }`}
                aria-label="Menu navigasi admin"
            >
                {/* Brand / Wordmark */}
                <div className="flex items-center justify-between gap-2 px-5 h-16 border-b border-vgs-gray-border shrink-0">
                    <Link
                        href="/"
                        onClick={close}
                        className="flex items-center gap-2.5 group focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-vgs-blue-electric rounded-lg px-1 py-0.5"
                    >
                         <img
                                src="/images/logo/logo..vgs2.png"
                                alt="VGS Logo"
                                className="w-13 sm:w-13 object-contain drop-shadow-[0_0_30px_var(--vgs-blue-electric)] transition-transform duration-500 hover:scale-105"
                            />
                           
                        <div className="flex flex-col leading-none">
                            <span className="font-display font-extrabold text-lg tracking-wider text-vgs-silver-bright">
                                V<span className="text-vgs-blue-electric">G</span>S
                            </span>
                            <span className="text-[8px] font-mono tracking-widest text-vgs-silver-muted uppercase">
                                Vortix Gaming Store
                            </span>
                        </div>
                    </Link>

                    {/* Close for mobile */}
                    <button
                        type="button"
                        onClick={close}
                        className="md:hidden flex items-center justify-center w-10 h-10 rounded-lg bg-vgs-black-elevated border border-vgs-gray-border text-vgs-silver-mid hover:text-white hover:border-vgs-blue-electric transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-vgs-blue-electric"
                        aria-label="Tutup menu navigasi"
                    >
                        <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </button>
                </div>

                {/* Admin Panel label */}
                <div className="px-5 pt-4 pb-2 shrink-0">
                    <span className="inline-flex items-center gap-2 px-2.5 py-1 rounded-md bg-vgs-blue-electric/10 border border-vgs-blue-electric/25 text-vgs-blue-electric font-mono text-[10px] uppercase tracking-widest">
                        <span className="w-1.5 h-1.5 rounded-full bg-vgs-blue-electric" />
                        Admin Panel
                    </span>
                </div>

                {/* Navigation */}
                <nav className="flex-1 overflow-y-auto px-3 pb-4 space-y-5">
                    {groups.map((group, gi) => (
                        <div key={gi}>
                            {group.label && (
                                <p className="px-3 mb-1.5 text-[10px] font-mono uppercase tracking-widest text-vgs-silver-muted">
                                    {group.label}
                                </p>
                            )}
                            <ul className="space-y-1">
                                {group.items.map((item) => {
                                    const active = isItemActive(item);
                                    return (
                                        <li key={item.label}>
                                            <Link
                                                href={item.href}
                                                onClick={close}
                                                className={`flex items-center gap-3 px-3 py-2.5 min-h-[44px] rounded-xl text-sm font-semibold transition-all focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-vgs-blue-electric ${
                                                    active
                                                        ? 'bg-vgs-blue-electric/15 text-vgs-blue-electric border border-vgs-blue-electric/30'
                                                        : 'text-vgs-silver-mid hover:text-vgs-silver-bright hover:bg-vgs-black-elevated border border-transparent'
                                                }`}
                                                aria-current={active ? 'page' : undefined}
                                            >
                                                <span className={`shrink-0 ${active ? 'text-vgs-blue-electric' : 'text-vgs-silver-muted'}`}>
                                                    {item.icon}
                                                </span>
                                                <span className="flex-1 truncate">{item.label}</span>
                                                {active && (
                                                    <span className="w-1.5 h-1.5 rounded-full bg-vgs-blue-electric shadow-[0_0_8px_var(--vgs-blue-electric)]" />
                                                )}
                                            </Link>
                                        </li>
                                    );
                                })}
                            </ul>
                        </div>
                    ))}
                </nav>

                {/* User info + logout */}
                <div className="border-t border-vgs-gray-border p-3 shrink-0">
                    <div className="flex items-center gap-3 px-2 py-2">
                        <div className="w-10 h-10 rounded-xl bg-vgs-blue-electric/20 border border-vgs-blue-electric/30 flex items-center justify-center text-vgs-blue-electric font-display font-bold text-sm shrink-0">
                            {initials}
                        </div>
                        <div className="flex-1 min-w-0">
                            <p className="text-sm font-semibold text-vgs-silver-bright truncate">
                                {displayUser?.name ?? 'Pengguna'}
                            </p>
                            <p className="text-xs text-vgs-silver-muted font-mono truncate">{roleName}</p>
                        </div>
                    </div>
                    <button
                        type="button"
                        onClick={handleLogout}
                        className="flex items-center gap-3 w-full mt-1 px-3 py-2.5 min-h-[44px] rounded-xl text-sm text-vgs-silver-mid hover:text-vgs-danger hover:bg-vgs-danger/10 transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-vgs-danger cursor-pointer"
                    >
                        <svg className="w-5 h-5 text-vgs-silver-muted" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
                        </svg>
                        <span className="font-semibold">Keluar</span>
                    </button>
                </div>
            </aside>
        </>
    );
};

export default Sidebar;
