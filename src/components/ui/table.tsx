/** Styled table primitives; no data, no app state. */
export function Table(props: { children: React.ReactNode }) {
    return <table className="w-full text-sm">{props.children}</table>;
}

export function TableRow(props: { children: React.ReactNode }) {
    return <tr className="border-b">{props.children}</tr>;
}

export function TableCell(props: { children: React.ReactNode }) {
    return <td className="px-3 py-2">{props.children}</td>;
}
