
app.service('dataService', function($http) {
    this.getData = function(request) {
        console.log(request);
        // $http() returns a $promise that we can add handlers with .then()
        return $http({
            method: 'GET',
            url: request.endPointUrl,
        });
    };
});

app.controller('FermentorStatusController', function($scope, dataService) {

    $scope.thing = 'Hello, world!';

    $scope.options = {
        chart: {
            type: 'lineChart',
            height: 450,
            margin: {
                top: 20,
                right: 20,
                bottom: 40,
                left: 55
            },
            x: function(d) {
                return d.x;
            },
            y: function(d) {
                return d.y;
            },
            useInteractiveGuideline: true,
            dispatch: {
                stateChange: function(e) {
                    console.log("stateChange");
                },
                changeState: function(e) {
                    console.log("changeState");
                },
                tooltipShow: function(e) {
                    console.log("tooltipShow");
                },
                tooltipHide: function(e) {
                    console.log("tooltipHide");
                }
            },
            xAxis: {
                axisLabel: 'Date',
                tickFormat: function(d) {
                    return moment.unix(d).format("dd MMM Do gggg HH:mm:ss");
                },
                staggerLabels: true,
            },
            yAxis: {
                axisLabel: 'Temperature (c)',
                tickFormat: function(d) {
                    return d3.format('.02f')(d);
                },
                axisLabelDistance: -10
            },
            callback: function(chart) {
                console.log("!!! lineChart callback !!!");
            }
        },
        title: {
            enable: true,
            text: 'Fermenter One - Temp Chart'
        },
    };

    var request = {
        endPointUrl: 'http://192.168.1.9:1469/sensors/fermentorone/',
        params: ''
    };

    $scope.data = null;
    dataService.getData(request).then(function(dataResponse) {
        console.log(dataResponse);
        $scope.data = dataResponse.data;
    });

    console.log(JSON.stringify($scope.data));

});

