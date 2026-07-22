# Título:
Use safe navigation e guard clauses em vez de nil checks aninhados

## Descrição:
  Evite condicionais aninhadas para checar nil. Prefira o safe navigation operator
  (&.) e guard clauses com early return no início do método.

  Sinalize código que faz `if obj && obj.attr && obj.attr.value` — deve virar
  `obj&.attr&.value`. Sinalize métodos que envolvem toda a lógica num `if` grande em
  vez de retornar cedo quando a pré-condição não é satisfeita.

## Ruim:
    def full_name(user)
      if user
        if user.profile
          "#{user.profile.first} #{user.profile.last}"
        end
      end
    end

## Bom:
    def full_name(user)
      return unless user&.profile
      "#{user.profile.first} #{user.profile.last}"
    end