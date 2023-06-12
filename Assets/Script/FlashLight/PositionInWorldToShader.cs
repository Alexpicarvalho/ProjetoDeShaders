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
        // Obtém a posição do ponto para o qual o objeto está apontando
        Vector3 pointedPosition = GetPointedPosition();

        m_MeshRenderer.SetVector("_VectorGlovalPosition", pointedPosition);
    }

    private Vector3 GetPointedPosition()
    {
        
        Vector3 mousePosition = Input.mousePosition;
        ray = new Ray (transform.position, transform.forward);
        RaycastHit hit;

        // Realiza o lançamento do raio e verifica se houve colisão
        if (Physics.Raycast(ray, out hit))
        {
            
            _distance=hit.distance;
            return hit.point;
        }

        else _distance = 200;

        // Caso contrário, retorna uma posição arbitrária (por exemplo, a posição do mouse no plano XY)
        return new Vector3(mousePosition.x, mousePosition.y, 0);
    }

    private void OnDrawGizmos()
    {
        Gizmos.color = Color.green;
        //Gizmos.DrawRay(ray.origin, ray.direction);

        Gizmos.DrawLine(ray.origin, ray.direction*_distance+ray.origin);
    }
}
