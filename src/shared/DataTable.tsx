import { Table, TableCell, TableRow } from '../components/ui/table';

export function DataTable<Row>(props: {
    rows: Row[];
    columns: { key: keyof Row; label: string }[];
}) {
    return (
        <Table>
            {props.rows.map((row, i) => (
                <TableRow key={i}>
                    {props.columns.map((column) => (
                        <TableCell key={String(column.key)}>{String(row[column.key])}</TableCell>
                    ))}
                </TableRow>
            ))}
        </Table>
    );
}
