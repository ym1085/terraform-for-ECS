[
    {
      "name": "${ecs_task_container_name}-${ecs_task_environment}",
      "image": "${ecs_task_ecr_image_arn}",
      "cpu": ${ecs_task_container_cpu},
      "memory": ${ecs_task_container_mem},
      "portMappings": [
        {
          "hostPort": ${ecs_task_container_port}
          "containerPort": ${ecs_task_container_port},
          "protocol": "tcp"
        }
      ],
      "environment": [
          { "name": "TZ", "value" : "Asia/Seoul"},
          { "name": "SPRING_PROFILES_ACTIVE", "value" : "stage"}
     ],
      "essential": ${ecs_task_essential},
      "mountPoints": [
          {
               "sourceVolume": "search-shared-volume",
               "containerPath": "/data/",
               "readOnly": false
          }
     ],
     "volumesFrom": [],
     "linuxParameters": {
          "capabilities": {
          "add": [],
          "drop": []
          }
     },
     "disableNetworking": false,
     "privileged": false,
     "readonlyRootFilesystem": false,
     "pseudoTerminal": false,
     "dockerLabels": {
          "map-migrated": "d-server-00pq62lmigxr9w",
          "createby": "ymkim",
          "teamtag": "AG",
          "env": "${ecs_task_environment}",
          "Name": "${ecs_task_container_name}-${ecs_task_environment}",
          "servicetag": "search-w-d"
     },
     "healthCheck": {
          "command": [
               "CMD-SHELL",
               "curl --location --request GET 'http://127.0.0.1:10091/explore/health-check' \\\n--header 'x-request-svc: MS_9999' \\\n--header 'Content-Type: application/json' || exit 1"
          ],
          "interval": 30,
          "timeout": 10,
          "retries": 5
     },
     "tags": [
          { "name": "Name", "value": "" },
          { "name": "Env", "value": "${ecs_task_environment}" },
          { "name": "createdby", "value" : "ymkim"},
          { "name": "env", "value" : "stg"},
          { "name": "map-migrated", "value" : "d-server-00pq62lmigxr9w"},
          { "name": "service", "value" : "search-recommend"},
          { "name": "servicetype", "value" : "ecs"},
          { "name": "teamtag", "value" : "AG"},
     ]
]