import { Button } from '../components/ui/button';

export function EmptyState(props: { message: string; onRetry: () => void }) {
    return (
        <div>
            <p>{props.message}</p>
            <Button onClick={props.onRetry}>Retry</Button>
        </div>
    );
}
