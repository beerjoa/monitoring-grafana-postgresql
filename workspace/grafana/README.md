#  Configuraions Grafana and PostgreSQL (writing...)

## Structure
```bash
./workspace/grafana
├── docker-compose.yml
├── README.md
├── postgresql
│  └── init.sql                           # init sql
└── grafana
   ├── provisioning
   │  ├── datasources
   │  │  └── datasource.yml               # init datasource
   │  └── dashboards
   │     ├── default-linux-server.json
   │     └── dashboard.yml                # init dashboard
   └── config
      └── grafana.ini                     # grafana config

```

