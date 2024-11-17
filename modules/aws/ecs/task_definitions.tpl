[
     %{ for container in containers }
     {
          "name": "${container.name}-${environment}",
          "image": "${container.image}:${container.version}",
          "cpu": "${container.cpu}",
          "memory": "${container.memory}",
          "essential": "${container.essential}",
     }
     %{ endfor}
]