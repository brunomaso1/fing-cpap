# Artificial Intelligence and Quantum Computing for Earth Observation (AIQC4EO)

## Descripción del curso

Este curso se brinda en el marco de [Herit4Future](https://herit4future.it/), el cual es un proyecto que promueve la colaboración entre instituciones de Italia y America Latina para desarrollar programas de formación innovadores y transaccionales.

![Herit4Future](/resources/image.png "Herit4Future")

Específicamente, este curso pertenece al programa de formación avanzada (Cursos de habilidades avanzadas), en el WP7 - "Aeroespacial para el Patrimonio y la Innovación". Puede obtenerse más información sobre el proyecto en la [página oficial del curso.](https://herit4future.it/deep-learning-and-quantum-computing-for-earth-observation/).

Profesores:
- Prof. Paolo Gamba (Universidad de Pavía, Italia)
- PhD. Alessandro Sebastiani (Universidad de Sannio, Italia)

El curso finalizó con una instancia presencial en Pavía (Italia).

## Temario

El temario completo se puede acceder en el siguiente enlace: [Syllabus](https://alessandrosebastianelli.github.io/qc4eo-slides/#/overview).

Módulos del curso:
- Módulo 1: Foundations
  - Introduction & Course Overview (Theory)
    - Foundations of Remote Sensing
    - Foundations of Machine Learning
  - Overview of Deep Learning Models
    - Convolutional Neural Networks
    - Recurrent Neural Networks
    - Generative Neural Networks
  - AI4EO practical session (practice)
    - ML Clustering
    - DL AutoEncoder
- Módulo 2: Quantum Computing Foundations
  - Introduction to Quantum Machine Learning
    - Quantum Computing Motivation
    - Current trends in QML4EO
    - Introduction to Quantum Theory
  - Quantum theory part II
    - Measuring qubits
    - Implementing quantum circuits
  - Strategies of input encoding
    - Input encoding theory background
    - Implementing input encoding on Pennylane
- Variational Quantum Models
  - Variational Circtuis
    - How to interpret a quantum circuit as a model
    - Which functions do VQMs express?
    - Training VQMs
    - Quantum circuits and NNs
  - Variational Circtuis (practice I)
  - Variational Circtuis (practice II)
  - Variational Circtuis (practice III)
  - Variational Circtuis (practice IV)
  - Variational Circtuis (practice V)
- New trends and closing remarks
  - Current and New trends in QML4EO
    - Quantum Convolution
    - Quantum Graph Neural Network
    - Quantum Diffusion
  - Quantum Kernel Methods
    - Quantum Kernel Methods (Theory)
    - Quantum Kernel Methods (Practical)
  - QK4EO
  - Course Evaluation

## Proyecto final

El proyecto final consistió en la implementación de un modelo de aprendizaje automático o aprendizaje profundo para resolver un problema puntual, integrando conceptos de los circuitos cuánticos. En este caso, se resolvió un problema de segmentación mediante la utilización de un modelo al estilo UNet pero con un circuito cuántico en el espacio de mayor compresión.

Se puede ver el código completo del proyecto en el siguiente enlace: [Proyecto final](https://github.com/iLavaU/proyecto-grupo-a-qc)

## Comandos útiles

### Conda

- Crear entorno:
```powershell
# Crea el entorno con la carpeta .venv dentro del directorio actual.
# Con la versión de Python 3.11
conda create --prefix ./.venv python=3.11
```

- Listar entornos:
```powershell
conda env list
```

- Activar entorno:
```powershell
conda activate ./.venv
```

- Desactivar entorno:
```powershell
conda deactivate
```

- Eliminar entorno:
```powershell
conda env remove --prefix ./.venv
```

- Chequear versión de python del entorno activo:
```powershell
python --version
```

- Chequear versión de python del ambiente creado:
```powershell
conda list -p .\.venv python
```

- Instalar una versión específica de python en el entorno activo:
```powershell
conda install python=3.11
```

- Agregar dependencia:
```powershell
conda install <package-name>
```

- Instalar dependencias desde archivo:
```powershell
conda install --yes --file requirements.txt # Con conda no funciona, hay que agregar conda-forge, el repositorio comunitario.
pip install -r requirements.txt # Con pip funciona bien.
```

- Clonar un ambiente:
```powershell
conda create --name myclone --clone myenv
```

- Agregar canal conda-forge:
```powershell
conda config --add channels conda-forge
conda config --set channel_priority strict
```

### Git

- Agregar submódulo:
```powershell
git submodule add https://github.com/iLavaU/proyecto-grupo-a-qc
```

- Clonar repositorio con submódulos:
```powershell
git clone --recurse-submodules <repository-url>
```