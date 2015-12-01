/* globals angular */
(function() {
    angular.module('google-chart-sample', ['googlechart', 'googlechart-docs'])
        .controller('HideSeriesController', HideSeriesController);

    HideSeriesController.$inject = ['$scope'];

    function HideSeriesController($scope) {
        // Properties
        $scope.chartObject = {};

        //Methods
        $scope.hideSeries = hideSeries;
        
        init();

        function hideSeries(selectedItem) {
            var col = selectedItem.column;
            if (selectedItem.row === null) {
                if ($scope.chartObject.view.columns[col] == col) {
                    $scope.chartObject.view.columns[col] = {
                        label: $scope.chartObject.data.cols[col].label,
                        type: $scope.chartObject.data.cols[col].type,
                        calc: function() {
                            return null;
                        }
                    };
                    $scope.chartObject.options.colors[col - 1] = '#CCCCCC';
                }
                else {
                    $scope.chartObject.view.columns[col] = col;
                    $scope.chartObject.options.colors[col - 1] = $scope.chartObject.options.defaultColors[col - 1];
                }
            }
        }

        function init() {
            $scope.chartObject.type = "LineChart";
            $scope.chartObject.displayed = false;
            $scope.chartObject.data = {
                "cols": [{
                    id: "month",
                    label: "Month",
                    type: "string"
                }, {
                    id: "laptop-id",
                    label: "Laptop",
                    type: "number"
                }, {
                    id: "desktop-id",
                    label: "Desktop",
                    type: "number"
                }, {
                    id: "server-id",
                    label: "Server",
                    type: "number"
                }, {
                    id: "cost-id",
                    label: "Shipping",
                    type: "number"
                }],
                "rows": [{
                    c: [{
                        v: "January"
                    }, {
                        v: 19,
                        f: "42 items"
                    }, {
                        v: 12,
                        f: "Ony 12 items"
                    }, {
                        v: 7,
                        f: "7 servers"
                    }, {
                        v: 4
                    }]
                }, {
                    c: [{
                        v: "February"
                    }, {
                        v: 13
                    }, {
                        v: 1,
                        f: "1 unit (Out of stock this month)"
                    }, {
                        v: 12
                    }, {
                        v: 2
                    }]

                }, {
                    c: [{
                        v: "March"
                    }, {
                        v: 24
                    }, {
                        v: 5
                    }, {
                        v: 11
                    }, {
                        v: 6
                    }]
                }]
            };
            $scope.chartObject.options = {
                "title": "Sales per month",
                "colors": ['#0000FF', '#009900', '#CC0000', '#DD9900'],
                "defaultColors": ['#0000FF', '#009900', '#CC0000', '#DD9900'],
                "isStacked": "true",
                "fill": 20,
                "displayExactValues": true,
                "vAxis": {
                    "title": "Sales unit",
                    "gridlines": {
                        "count": 10
                    }
                },
                "hAxis": {
                    "title": "Date"
                }
            };

            $scope.chartObject.view = {
                columns: [0, 1, 2, 3, 4]
            };
        }
    }
})();
