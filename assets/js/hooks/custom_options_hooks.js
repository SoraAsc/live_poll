export const AddOption = {
    mounted() {
        this.el.addEventListener("click", () => {
            let inputElement = document.getElementById("option-input");
            let inputValue = inputElement.value;
      
            this.pushEvent("handle_click", { input_value: inputValue });
        });
    }
};
  