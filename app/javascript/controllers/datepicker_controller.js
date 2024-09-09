import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr";

export default class extends Controller {
  static targets = ["input"];

  connect() {

    flatpickr(this.inputTarget, {
      locale: {
        firstDayOfWeek: 1, // Início da semana na segunda-feira
        weekdays: {
          shorthand: ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sáb"],
          longhand: [
            "Domingo",
            "Segunda-feira",
            "Terça-feira",
            "Quarta-feira",
            "Quinta-feira",
            "Sexta-feira",
            "Sábado",
          ],
        },
        months: {
          shorthand: [
            "Jan",
            "Fev",
            "Mar",
            "Abr",
            "Mai",
            "Jun",
            "Jul",
            "Ago",
            "Set",
            "Out",
            "Nov",
            "Dez",
          ],
          longhand: [
            "Janeiro",
            "Fevereiro",
            "Março",
            "Abril",
            "Maio",
            "Junho",
            "Julho",
            "Agosto",
            "Setembro",
            "Outubro",
            "Novembro",
            "Dezembro",
          ],
        },
        rangeSeparator: " até ",
        time_24hr: true,
      },
      dateFormat: "d/m/Y"
    });
  }
}
