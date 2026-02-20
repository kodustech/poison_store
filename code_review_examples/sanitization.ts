interface UserInput {
  name: string;
  email: string;
}

declare const db: { insert: (data: { name: string; email: string }) => void };
declare function sanitizeHtml(s: string): string;

function saveUser(input: UserInput) {
  const name = sanitizeHtml(input.name);
  const email = input.email.trim().toLowerCase();
  db.insert({ name, email });
}
