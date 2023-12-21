from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, String, DateTime, func, select
from database.conexion import engine

Base = declarative_base()


class Acta(Base):
    __tablename__ = 'detalle_acta_compromiso'
    id_compromiso = Column(String, primary_key=True)
    id_caso = Column(String)
    ult_modificacion = Column(DateTime, default=func.now())
    estado = Column(Integer, default = 1)
    @classmethod
    def generate_id(cls):
        next_value = engine.execute(
            select(func.nextval('sec_id_acta_compromiso'))).scalar()
        return f"CO-{next_value}"
   