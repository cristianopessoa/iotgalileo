$( document ).ready(function() {
    pega_dados();
});

window.setTimeout(function() {
    $(".alert").fadeTo(500, 0).slideUp(500, function(){
        $(this).remove();
    });
}, 3000)

var selecionado = {
    nome : "",
    dado : [],
    grandeza : "",
    subtitutlo : ""
};
var inicio = true;

var tv;
var N_open;
var iKr;
var v;
var M1;
var M2;
var M3;
var M4;
var M5;

var N;
var tend;
var t_ap;
var Ap;
var dt;
var w;

function gera_grafico(){
    Highcharts.chart('container', {
    chart: {
            zoomType: 'x'
        },
    title: {
        text: selecionado.nome
    },
    subtitle: {
        text: selecionado.titulo
    },
    yAxis: {
        title: {
            text: selecionado.grandeza
        }
    },
    legend: {
        layout: 'vertical',
        align: 'right',
        verticalAlign: 'middle'
    },
    plotOptions: {
        series: {
            pointStart: 0,
            animation: {
                duration: 3000
                //easing: 'easeOutBounce'
            }
        }
    },
    series: [{
        name: selecionado.grandeza,
        data: selecionado.dado,
        type: 'spline',
        }]
    })
}

function pega_dados(){
    N = $('#N').val();
    tend = $('#tend').val();
    t_ap = $('#t_ap').val();
    Ap = $('#Ap').val();
    dt = $('#dt').val();
    w = $('#w').val();
    if (!N)
    {
        N = 100;
    }
    if (!tend)
    {
        tend = 2000;
    }
    if (!t_ap)
    {
        t_ap = 400;
    }
    if (!Ap)
    {
        Ap = 15;
    }
    if (!dt)
    {
        dt = 0.1;
    }
    if (!w)
    {
        w = 2000;
    }
    $.getJSON('/dado_grafico.json',
    {
        N: N,
        tend: tend,
        t_ap: t_ap,
        Ap: Ap,
        dt: dt,
        w: w
    })
    .done(function( data ){
        console.log("resposta");
        tv = data[0];
        N_open = data[1];
        iKr = data[2];
        v = data[3];
        M1 = data[4];
        M2 = data[5];
        M3 = data[6];
        M4 = data[7];
        M5 = data[8];
        if (inicio)
        {
            selecionado.dado = M4;
            selecionado.nome = "M4";
            selecionado.grandeza = "Hz";
            selecionado.titulo = "M4 - sei la o que é isso";
        }
        inicio = false;
        gera_grafico();
    });
}

$(".dropdown-menu li a").click(function(){
    $(this).parents(".dropdown").find('.btn').html($(this).text() + ' <span class="caret"></span>');
    $(this).parents(".dropdown").find('.btn').val($(this).data('value'));
    var sel = $(this).text();
    switch (sel) {
        case 'tv':
            selecionado.dado = tv;
            selecionado.nome = "tv";
            selecionado.grandeza = "Segundos";
            selecionado.titulo = "tv - sei la o que é isso";
            break;
        case 'N_open':
            selecionado.dado = N_open;
            selecionado.nome = "N_open";
            selecionado.grandeza = "Hz";
            selecionado.titulo = "N_open - sei la o que é isso";
            break;
        case 'iKr':
            selecionado.dado = iKr;
            selecionado.nome = "iKr";
            selecionado.grandeza = "Hz";
            selecionado.titulo = "iKr - sei la o que é isso";
            break;
        case 'v':
            selecionado.dado = v;
            selecionado.nome = "v";
            selecionado.grandeza = "Hz";
            selecionado.titulo = "v - sei la o que é isso";
            break;
        case 'M1':
            selecionado.dado = M1;
            selecionado.nome = "M1";
            selecionado.grandeza = "Hz";
            selecionado.titulo = "M1 - sei la o que é isso";
            break;
        case 'M2':
            selecionado.dado = M2;
            selecionado.nome = "M2";
            selecionado.grandeza = "Hz";
            selecionado.titulo = "M2 - sei la o que é isso";
            break;
        case 'M3':
            selecionado.dado = M3;
            selecionado.nome = "M3";
            selecionado.grandeza = "Hz";
            selecionado.titulo = "M3 - sei la o que é isso";
            break;
        case 'M4':
            selecionado.dado = M4;
            selecionado.nome = "M4";
            selecionado.grandeza = "Hz";
            selecionado.titulo = "M4 - sei la o que é isso";
            break;
        case 'M5':
            selecionado.dado = M5;
            selecionado.nome = "M5";
            selecionado.grandeza = "Hz";
            selecionado.titulo = "M5 - sei la o que é isso";
            break;
    default:
            selecionado.dado = M4;
            selecionado.nome = "M4";
            selecionado.grandeza = "Hz";
            selecionado.titulo = "M4 - sei la o que é isso";
  }
  gera_grafico();
});

$("#Atualizar").click(function(){
    gera_grafico();
});

$("#recalcular").click(function(){
    pega_dados();
});
