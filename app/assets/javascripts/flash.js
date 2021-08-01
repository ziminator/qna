document.addEventListener('turbolinks:load', function(){
    var control = document.querySelector('.flash');

    if (control) {control.addEventListener('click', sortRowsByTitle);
    }
})

function sortRowsByTitle() {
    var table = document.querySelector('table');

    // NodeList
    // https://developer.mozila.org/ru/docs/Web/API/NodeList
    var rows = table.querySelectorAll('tr');

    var sortedRows =[];

    //selects all table rows except 1st one which is the header
    for (var i = 1; i < rows.length; i++) {
        sortedRows.push(rows[i]);
    }


    if (this.querySelector('.octicon-arrow-up').classList.contains('hide')) {
        sortedRows.sort(compareRowsAsc); // <=> compares elements
        this.querySelector('.octicon-arrow-up').classList.remove('hide');
        this.querySelector('.octicon-arrow-down').classList.add('hide');
    } else {
        sortedRows.sort(compareRowsDesc); // <=> compares elements
        this.querySelector('.octicon-arrow-down').classList.remove('hide');
        this.querySelector('.octicon-arrow-up').classList.add('hide');
    }

    var sortedTable = document.createElement('table'); //creates a new element (in memory)

    sortedTable.classList.add('table'); // classList returns collection of css elements, 'add' adds to local var
    sortedTable.appendChild(rows[0]); //Next we add 1st row with the Title. For now it's in memory, func works fast.

    for (var i = 0; i < sortedRows.length; i++) {
        sortedTable.appendChild(sortedRows[i]);
    }

    table.parentNode.replaceChild(sortedTable, table) //Loking for parent node, replacing old table with sorted one
}

function compareRowsAsc(row1, row2) {
    var testTitle1 = row1.querySelector('td').textContent; // selects 1st element with 'Title'
    var testTitle2 = row2.querySelector('td').textContent;

    if (testTitle1 < testTitle2) {return -1}
    if (testTitle1 > testTitle2) {return 1}
    return 0
}

function compareRowsDesc(row1, row2) {
    var testTitle1 = row1.querySelector('td').textContent; // selects 1st element with 'Title'
    var testTitle2 = row2.querySelector('td').textContent;

    if (testTitle1 < testTitle2) {return 1}
    if (testTitle1 > testTitle2) {return -1}
    return 0
}
