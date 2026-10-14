# Omarchy_Escala

Um único calendário na barra do Omarchy: os eventos do [omarchy-calendar](https://github.com/tmn73/omarchy-calendar) e uma escala de serviço recorrente. Esta versão combina o omarchy-calendar 0.7.4 com a escala criada neste projeto. O código do calendário original é distribuído sob a licença MIT, preservada em [LICENSE](LICENSE).

## Instalação

Clone este repositório e execute `./install.sh`. O instalador valida o plugin, faz backup de `~/.config/omarchy/shell.json`, instala `lucas.calendar` e troca as entradas `lucas.clock` e `tmn73.calendar` da barra por um único calendário. A configuração atual da escala e as preferências do omarchy-calendar são copiadas para a nova entrada. Os plugins antigos continuam no disco, mas saem da barra.

Se o Omarchy Shell estiver aberto e não aplicar a mudança automaticamente, execute `omarchy restart shell`.

## Escala

Abra o calendário e, sob o mês, escolha **Configurar**. Informe a data do primeiro dia de serviço em `AAAA-MM-DD`, a quantidade de dias seguidos de serviço e os dias seguidos de folga. Exemplo: `2026-10-21`, `2`, `6`. O resumo mostra o próximo serviço, incluindo hoje quando for dia de serviço.

Um clique normal no dia continua selecionando a agenda. Para adicionar serviço avulso ou retirar um plantão, selecione o dia e use o botão ao lado de **Configurar**. Clique novamente em **Remover avulso** para desfazer. A exceção altera apenas a data selecionada; o ciclo seguinte mantém a sequência original. Dias de serviço têm fundo colorido e exceções têm borda colorida. Os pontos de eventos do calendário continuam visíveis.

Os dados da escala ficam na entrada `lucas.calendar` de `~/.config/omarchy/shell.json`. Eventos sincronizados continuam em `~/.local/state/omarchy/calendar-events.json`. Este repositório não contém seus eventos ou credenciais.

Para configurar a sincronização de eventos, consulte a [documentação do omarchy-calendar](https://github.com/tmn73/omarchy-calendar#readme). Se já existe uma sincronização, o calendário combinado continua lendo o mesmo arquivo de eventos. Se for remover o plugin original, execute antes `~/.config/omarchy/plugins/lucas.calendar/sync/setup` para atualizar o caminho do serviço de sincronização.
