export function Button(props: { onClick: () => void; children: React.ReactNode }) {
    return <button className="rounded px-3 py-1" onClick={props.onClick}>{props.children}</button>;
}
