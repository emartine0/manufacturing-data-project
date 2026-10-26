## 📂 Repository Structure
```
manufacturing-data-project/
|
├── SQL/
|   │
|   ├── data/                              # Raw datasets used for the project (csv files)
|   │
|   ├── docs/                               # Project documentation and architecture details
|   │   ├── data_catalog.md                 # Dataset catalog, including fiel and metadata descriptions
|   │   └── naming-conventions.md           # Consistent naming guidelines for tables, columns, and files
|   │
|   ├── scripts/                            # SQL scripts for ETL and transformations
|   │   ├── bronze/                         # Scripts for extracting and loading raw data
|   │   ├── silver/                         # Scripts for cleaning and transforming data
|   │   └── gold/                           # Scripts for creating analytical models
|   │
|   └── tests/                              # Test scripts and quality files
|
├── Tableau/
|   ├── manufacturing_dashboard.jpg          # Screenshot of the dashboard
|   ├── manufacturing_dashboard.twbx         # Tableau workfile
|   ├── manufacturing_data.csv               # Dataset used for visualization
|   ├── user_requirements.md                 # Final user requirements
|   └── README.md                            # Tableau project overview and link to the dashboard
|
│   
├── README.md                               # Project overview and guidelines
└── LICENSE                                 # License information for the repository
```
