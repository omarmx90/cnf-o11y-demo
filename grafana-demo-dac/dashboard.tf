resource "grafana_dashboard" "example_dashboard" {
  config_json = jsonencode({
    "annotations": {
      "list": [
        {
          "builtIn": 1,
          "datasource": {
            "type": "grafana",
            "uid": "-- Grafana --"
          },
          "enable": true,
          "hide": true,
          "iconColor": "rgba(0, 211, 255, 1)",
          "name": "Annotations & Alerts",
          "type": "dashboard"
        }
      ]
    },
    "editable": true,
    "fiscalYearStartMonth": 0,
    "graphTooltip": 0,
    "id": 7,
    "links": [],
    "panels": [
      {
        "datasource": {
          "type": "prometheus",
          "uid": "webstore-metrics"
        },
        "gridPos": {
          "h": 25,
          "w": 11,
          "x": 0,
          "y": 0
        },
        "id": 2,
        "options": {
          "showImage": true
        },
        "pluginVersion": "11.1.0",
        "targets": [
          {
            "datasource": {
              "type": "prometheus",
              "uid": "webstore-metrics"
            },
            "disableTextWrap": false,
            "editorMode": "builder",
            "expr": "target_info{cloud_platform=\"aws_ec2\"}",
            "fullMetaSearch": false,
            "includeNullMetadata": true,
            "instant": false,
            "legendFormat": "__auto",
            "range": true,
            "refId": "A",
            "useBackend": false
          }
        ],
        "title": "DEMO EPAM",
        "type": "news"
      },
      {
        "datasource": {
          "type": "grafana-opensearch-datasource",
          "uid": "P9744FCCEAAFBD98F"
        },
        "gridPos": {
          "h": 25,
          "w": 13,
          "x": 11,
          "y": 0
        },
        "id": 1,
        "options": {
          "dedupStrategy": "none",
          "enableLogDetails": true,
          "prettifyLogMessage": false,
          "showCommonLabels": false,
          "showLabels": false,
          "showTime": false,
          "sortOrder": "Descending",
          "wrapLogMessage": false
        },
        "targets": [
          {
            "alias": "",
            "bucketAggs": [
              {
                "field": "observedTimestamp",
                "id": "2",
                "settings": {
                  "interval": "auto"
                },
                "type": "date_histogram"
              }
            ],
            "datasource": {
              "type": "grafana-opensearch-datasource",
              "uid": "P9744FCCEAAFBD98F"
            },
            "format": "logs",
            "key": "Q-557f1449-9cb7-4443-bbbc-2b20c9d6e18e-0",
            "metrics": [
              {
                "id": "1",
                "type": "count"
              }
            ],
            "query": "",
            "queryType": "PPL",
            "refId": "A",
            "timeField": "observedTimestamp"
          }
        ],
        "title": "Logging DEMO EPAM",
        "type": "logs"
      }
    ],
    "schemaVersion": 39,
    "tags": [
      "grafana",
      "metrics",
      "EPAM",
      "DEMO"
    ],
    "templating": {
      "list": []
    },
    "time": {
      "from": "now-1h",
      "to": "now"
    },
    "timepicker": {},
    "timezone": "browser",
    "title": "Dashboard Epam Demo",
    "uid": "bdw5knczd5qtcc",
    "version": 5,
    "weekStart": ""
  })
}