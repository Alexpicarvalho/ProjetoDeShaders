using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Scripting;
using UnityEngine.UIElements;

public class PositionInWorldToShader : MonoBehaviour
{
    [SerializeField] Material m_MeshRenderer;

    Ray ray;
    float _distance;

    private void Update()
    {
        // Obt�m a posi��o do ponto para o qual o objeto est� apontando
        Vector3 pointedPosition = GetPointedPosition();

        m_MeshRenderer.SetVector("_VectorGlovalPosition", pointedPosition);
    }

    private Vector3 GetPointedPosition()
    {
        
        Vector3 mousePosition = Input.mousePosition;
        ray = new Ray (transform.position, transform.forward);
        RaycastHit hit;

        // Realiza o lan�amento do raio e verifica se houve colis�o
        if (Physics.Raycast(ray, out hit))
        {
            
            _distance=hit.distance;
            return hit.point;
        }

        else _distance = 200;

        // Caso contr�rio, retorna uma posi��o arbitr�ria (por exemplo, a posi��o do mouse no plano XY)
        return new Vector3(mousePosition.x, mousePosition.y, 0);
    }

    private void OnDrawGizmos()
    {
        Gizmos.color = Color.green;
        //Gizmos.DrawRay(ray.origin, ray.direction);

        Gizmos.DrawLine(ray.origin, ray.direction*_distance+ray.origin);
    }
}
