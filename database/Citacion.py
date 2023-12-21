# base de datos

from database.conexion import session
from models.Citacion import Citacion
from sqlalchemy import and_
import datetime
async def insertCitacion(data, id_caso, numero):
    try:
        fecha_citacion = data.get('fecha_citacion')
        fecha_creacion = data.get('fecha_creacion')
        hora_citacion = data.get('hora_citacion')
        citacion = Citacion(fecha_creacion = fecha_creacion, id_citacion = Citacion.generate_id(),
                                id_caso = id_caso, fecha_citacion = fecha_citacion, hora_citacion = hora_citacion,
                                numero = numero, suspendido=0)
        session.add(citacion)
        session.commit()
        return citacion.id_citacion
    except Exception as e:
        print(e)

async def allCitacionByCaso(id_caso):
    citaciones= session.query(Citacion).filter(and_(Citacion.id_caso == id_caso)).all()
    return citaciones

async def suspenderCitacion(id_citacion):
    citacion = session.query(Citacion).filter_by(id_citacion = id_citacion).first()
    citacion.suspendido = 1
    citacion.ult_modificacion = datetime.datetime.now()
    session.commit()
    
    return citacion.id_citacion

async def terminarCitacion(id_citacion):
    citacion = session.query(Citacion).filter_by(id_citacion = id_citacion).first()
    citacion.estado = 0
    citacion.ult_modificacion = datetime.datetime.now()
    session.commit()
    return citacion.id_citacion