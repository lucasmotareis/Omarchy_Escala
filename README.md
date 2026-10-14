# Omarchy_Escala

Calendário de serviço para Omarchy.

Plugin local baseado no relógio do Omarchy 4.0.4. Ele mostra uma escala recorrente no calendário, calcula o próximo serviço a partir de hoje e guarda alterações no `~/.config/omarchy/shell.json`.

## Uso

1. Clique no relógio da barra.
2. Escolha **CONFIGURAR ESCALA**.
3. Digite a data do primeiro dia de serviço em `AAAA-MM-DD`, a quantidade de dias seguidos de serviço e a quantidade de dias seguidos de folga. Exemplo: `2026-10-14`, `2`, `6`.
4. Clique em **SALVAR**. O dia inicial conta como o primeiro dia de serviço.
5. Clique num dia do calendário para criar uma exceção: num dia de folga, adiciona serviço; num dia de serviço, marca folga. Clique novamente para remover a exceção.

Os dias de serviço recebem fundo colorido. Uma borda colorida indica um dia avulso ou uma folga excepcional; o dia de hoje também tem borda. O resumo mostra o próximo serviço **incluindo hoje**. As exceções não deslocam a sequência da escala.

Para mudar a configuração depois, abra **CONFIGURAR ESCALA** novamente. O relógio mantém seus formatos e outras preferências já existentes.

## Instalação

Execute `./install.sh` nesta pasta. O script faz backup de `shell.json`, instala o plugin em `~/.config/omarchy/plugins/lucas.clock` e substitui a entrada `omarchy.clock` na barra por `lucas.clock`. A configuração do relógio é copiada para a nova entrada. Se o Omarchy Shell estiver aberto, reinicie com `omarchy restart shell` caso a mudança não apareça automaticamente.
