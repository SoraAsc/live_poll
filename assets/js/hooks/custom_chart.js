import { Chart, registerables } from 'chart.js'
Chart.register(...registerables)

export const CustomChart = {
    mounted() {
        this.createChart()
    },

    updated() {
        this.createChart()
    },

    createChart() {
        let ctx = this.el.getContext('2d')
        const type = this.el.getAttribute('data-type') || 'bar'
        const label = this.el.getAttribute('data-label') || 'Poll'
        const labels = this.el.getAttribute('data-labels') || ["Poll"]
        const data = this.el.getAttribute('data-dataset') || [0]
        alert(data)
        new Chart(ctx, {
            type,
            data: 
            {
                labels: labels,//['January', 'February', 'March', 'April', 'May', 'June', 'July'],
                datasets: [{
                  label: label,
                  data: data,//[65, 59, 80, 81, 56, 55, 40],
                  backgroundColor: 'rgba(75, 192, 192, 0.2)',
                  borderColor: 'rgba(75, 192, 192, 1)',
                  borderWidth: 1
                }]
            },
            options: 
            {
                scales: {
                  y: {
                    beginAtZero: true
                  }
                },
                maintainAspectRatio: false,
                responsive: false,
            }
        })
        // let table = document.createElement("table")
        // table.innerHTML = `
        //     <tr class="bg-red-900">
        //         <th>Header 1</th>
        //         <th>Header 2</th>
        //     </tr>
        //     <tr>
        //         <td>Data 1</td>
        //         <td>Data 2</td>
        //     </tr>
        // `
        // this.el.innerHTML = ""
        // this.el.appendChild(table)
    }
}